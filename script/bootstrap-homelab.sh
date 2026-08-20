#!/usr/bin/env bash
# Idempotent homelab bootstrap for trackdays.ru behind Caddy.
# Does not touch Immich compose, obshak, Apache, or ports 80/443/2283/3000.
set -euo pipefail

APP_ROOT="/home/difry/projects/trackdays"
IMMICH_CADDY="/home/difry/projects/immich/Caddyfile"
ETC_CADDY="/etc/caddy/Caddyfile"
UNIT_SRC="${APP_ROOT}/deploy/trackdays.service"
UNIT_DST="${HOME}/.config/systemd/user/trackdays.service"
PORT=3001
DB_NAME="trackdays_production"

CADDY_BLOCK=$'trackdays.ru, www.trackdays.ru {\n\treverse_proxy 127.0.0.1:3001\n}'

log() { printf '==> %s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# Run via login shell so RVM loads cleanly (RVM is incompatible with set -u).
run_ruby() {
  bash -lc "cd '${APP_ROOT}' && rvm use 3.1.2 >/dev/null && $*"
}

preflight() {
  log "Preflight checks"
  command -v psql >/dev/null || die "psql not found"
  command -v curl >/dev/null || die "curl not found"
  systemctl is-active --quiet caddy || die "caddy is not active"
  if systemctl is-active --quiet apache2 2>/dev/null; then
    die "apache2 is active — refuse to proceed"
  fi

  bash -lc 'rvm use 3.1.2 >/dev/null && ruby -v' | grep -q '3.1.2' \
    || die "Expected Ruby 3.1.2 via RVM"

  local dns
  dns="$(dig +short +time=2 +tries=2 @8.8.8.8 trackdays.ru A 2>/dev/null | grep -E '^[0-9.]+$' | head -1 || true)"
  if [[ -z "${dns}" ]]; then
    dns="$(dig +short +time=2 +tries=2 trackdays.ru A 2>/dev/null | grep -E '^[0-9.]+$' | head -1 || true)"
  fi
  if [[ "${dns}" != "91.214.240.191" ]]; then
    log "WARN: DNS check got '${dns:-empty}' (expected 91.214.240.191) — continuing anyway"
  fi

  if ss -tln | grep -qE "127.0.0.1:${PORT}|0.0.0.0:${PORT}"; then
    if systemctl --user is-active --quiet trackdays.service 2>/dev/null; then
      log "Port ${PORT} already used by trackdays.service (ok)"
    else
      die "Port ${PORT} is in use by something other than trackdays.service"
    fi
  fi
}

ensure_database() {
  log "PostgreSQL database ${DB_NAME}"
  if psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1; then
    log "Database already exists"
  else
    createdb "${DB_NAME}"
    log "Created ${DB_NAME}"
  fi
}

bundle_and_assets() {
  log "bundle install + db:prepare + assets:precompile"
  run_ruby 'bundle check >/dev/null 2>&1 || bundle install'
  run_ruby 'RAILS_ENV=production bundle exec rails db:prepare'
  run_ruby 'RAILS_ENV=production bundle exec rails assets:precompile'
}

maybe_seed() {
  log "Seed if empty"
  local count
  count="$(run_ruby "RAILS_ENV=production bundle exec rails runner 'puts Track.count'" | tail -1)"
  if [[ "${count}" == "0" ]]; then
    run_ruby 'RAILS_ENV=production bundle exec rails db:seed'
    log "Seeded demo data"
  else
    log "Tracks already present (${count}), skip seed"
  fi
}

install_systemd_unit() {
  log "Install systemd user unit"
  mkdir -p "${HOME}/.config/systemd/user"
  install -m 644 "${UNIT_SRC}" "${UNIT_DST}"
  systemctl --user daemon-reload
  systemctl --user enable trackdays.service
  systemctl --user restart trackdays.service
}

ensure_caddy_block_in_file() {
  local file="$1"
  if grep -qF 'trackdays.ru' "${file}"; then
    log "Caddy block already present in ${file}"
    return 1
  fi
  printf '\n%s\n' "${CADDY_BLOCK}" >> "${file}"
  log "Appended trackdays.ru block to ${file}"
  return 0
}

install_caddy() {
  log "Caddy vhost for trackdays.ru"
  local repo_changed=0 etc_needs_update=0

  if ensure_caddy_block_in_file "${IMMICH_CADDY}"; then
    repo_changed=1
  fi

  if ! grep -qF 'trackdays.ru' "${ETC_CADDY}" 2>/dev/null; then
    etc_needs_update=1
  fi

  if [[ "${etc_needs_update}" -eq 1 ]] || ! diff -q "${IMMICH_CADDY}" "${ETC_CADDY}" >/dev/null 2>&1; then
    log "Installing Caddyfile to ${ETC_CADDY}"
    if sudo -n true 2>/dev/null; then
      sudo install -m 644 "${IMMICH_CADDY}" "${ETC_CADDY}"
      sudo systemctl reload caddy
    elif command -v pkexec >/dev/null; then
      pkexec bash -c "install -m 644 '${IMMICH_CADDY}' '${ETC_CADDY}' && systemctl reload caddy" \
        || die "pkexec failed — run: sudo install -m 644 ${IMMICH_CADDY} ${ETC_CADDY} && sudo systemctl reload caddy"
    else
      die "Need sudo — run: sudo install -m 644 ${IMMICH_CADDY} ${ETC_CADDY} && sudo systemctl reload caddy"
    fi
    log "Caddy reloaded"
  else
    log "/etc/caddy/Caddyfile already up to date"
  fi

  if [[ "${repo_changed}" -eq 0 && "${etc_needs_update}" -eq 0 ]]; then
    log "Caddy already configured for trackdays.ru"
  fi
}

wait_for_app() {
  log "Wait for Puma on 127.0.0.1:${PORT}"
  local i
  for i in $(seq 1 30); do
    if curl -sf -o /dev/null -H "Host: trackdays.ru" "http://127.0.0.1:${PORT}/"; then
      log "App responds"
      return 0
    fi
    sleep 1
  done
  systemctl --user status trackdays.service --no-pager || true
  journalctl --user -u trackdays.service -n 40 --no-pager || true
  die "App did not become ready on 127.0.0.1:${PORT}"
}

healthcheck() {
  log "Health checks"
  curl -sI -H "Host: trackdays.ru" "http://127.0.0.1:${PORT}/" | head -5
  echo
  curl -sI "https://trackdays.ru/" | head -10
  echo
  log "Done. Useful commands:"
  echo "  systemctl --user status trackdays"
  echo "  systemctl --user restart trackdays"
  echo "  journalctl --user -u trackdays -f"
}

main() {
  preflight
  ensure_database
  bundle_and_assets
  maybe_seed
  install_systemd_unit
  install_caddy
  wait_for_app
  healthcheck
}

main "$@"
