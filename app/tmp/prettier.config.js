module.exports = {
  plugins: [
    require('prettier-plugin-tailwindcss'), // must come last
  ],
  printWidth: 80,
  semi: false,
  singleQuote: true,
  tabWidth: 2,
  tailwindConfig: './tailwind.config.js',
  trailingComma: 'all',
  useTabs: false,
}
