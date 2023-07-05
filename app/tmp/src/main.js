import './styles.css'
;(function () {
  const setupDom = () => {
    const headerLinks = [...document.querySelectorAll('.header-link')]
    if (!headerLinks.length) return null

    const headerNav = document.querySelector('#header-nav')
    if (!headerNav) return null

    return {
      headerLinks,
      headerNav,
    }
  }

  const main = () => {
    // const dom = setupDom()
    // if (!dom) return
  }

  window.addEventListener('load', main)
})()
