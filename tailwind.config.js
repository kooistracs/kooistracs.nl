/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./templates/**/*.html",
    "./content/**/*.md",
    "./_index.md",
  ],
  theme: {
    extend: {
      fontFamily: {
        'vertiga': ['Vertiga'],
      },
      typography: {
        DEFAULT: {
          css: {
            maxWidth: 'none',
            h1: {
              fontWeight: '700',
            },
            h2: {
              fontWeight: '600',
            },
            h3: {
              fontWeight: '600',
            },
          },
        },
      },
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#070838',
          600: '#070838',
          700: '#070838',
          800: '#070838',
          900: '#070838',
        },
      },
    },
  },
  plugins: [],
}
