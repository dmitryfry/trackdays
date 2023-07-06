import './styles.css'
import { setupDom } from './dom'
;(function () {
  const main = () => {
    const mobileMenuButtonName = 'mobileMenuButton'
    const mobileMenuName = 'mobileMenu'
    const mobileMenuOverlayName = 'mobileMenuOverlay'
    const selectors = [
      {
        id: 'mobile-menu',
        name: mobileMenuName,
      },
      {
        id: 'mobile-menu-button',
        name: mobileMenuButtonName,
      },
      {
        id: 'mobile-menu-overlay',
        name: mobileMenuOverlayName,
      },
    ]

    const dom = setupDom(selectors)
    if (!dom) return

    dom[mobileMenuButtonName].addEventListener('click', () => {
      dom[mobileMenuName].classList.toggle('hidden')
      dom[mobileMenuOverlayName].classList.toggle('hidden')
    })

    dom[mobileMenuOverlayName].addEventListener('click', () => {
      dom[mobileMenuName].classList.toggle('hidden')
      dom[mobileMenuOverlayName].classList.toggle('hidden')
    })

    dom[mobileMenuName].addEventListener('click', () => {
      dom[mobileMenuName].classList.toggle('hidden')
      dom[mobileMenuOverlayName].classList.toggle('hidden')
    })
  }

  window.addEventListener('load', main)
})()
