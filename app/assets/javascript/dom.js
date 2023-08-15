;(function (ns) {
  ns.setupDom = (selectors) => {
    const dom = {}

    for (let i = 0; i < selectors.length; i++) {
      const selector = selectors[i]
      if (selector.id) {
        dom[selector.name] = document.getElementById(selector.id)
        if (!dom[selector.name]) {
          console.error(`Element with id ${selector.id} not found`)
          return null
        }
      } else if (selector.class) {
        dom[selector.name] = [
          ...document.getElementsByClassName(selector.class),
        ]
        if (!dom[selector.name].length) {
          console.error(`Element with class ${selector.class} not found`)
          return null
        }
      } else {
        console.error(`Invalid selector ${selector}`)
        return null
      }
    }

    return dom
  }
})((window.mainPageNameSpace = window.mainPageNameSpace || {}))
