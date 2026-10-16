# frozen_string_literal: true

class SyncExternalEventsJob < ApplicationJob
  queue_as :default

  def perform(sources = nil)
    EventSync::Runner.new(sources: sources).call
  end
end
