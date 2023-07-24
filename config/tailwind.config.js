/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/assets/stylesheets/**/*.css',
    './app/assets/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {
      colors: {
        'custom-red': '#DA251C',
      },
      gridTemplateRows: {
        layout: 'auto 1fr auto',
      },
    },
    fontSize: {
      sm: '0.8rem',
      base: '1rem',
      xl: '1.25rem',
      '2xl': '1.5rem',
      '3xl': '2rem',
      '4xl': '2.441rem',
      '5xl': '3.052rem',
    },
  },
  plugins: [],
}
