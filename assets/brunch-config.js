exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["css/app.css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor|node_modules/]
    },
    copycat: {
      "fonts": [
        "node_modules/bootstrap-sass/assets/fonts/bootstrap",
        "node_modules/font-awesome/fonts"
      ] // copy node_modules/bootstrap-sass/assets/fonts/bootstrap/* to priv/static/fonts/
    },
    sass: {
      mode: "native", // This is the important part!
      options: {
        includePaths: [
          "node_modules/bootstrap-sass/assets/stylesheets",
          "node_modules/font-awesome/scss",
          "node_modules/toastr"
        ], // tell sass-brunch where to look for files to @import
        precision: 8 // minimum precision required by bootstrap-sass
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"]
    }
  },

  npm: {
    enabled: true,
    globals: { // bootstrap-sass' JavaScript requires both '$' and 'jQuery' in global scope
      $: 'jquery',
      jQuery: 'jquery',
      bootstrap: 'bootstrap-sass' // require bootstrap-sass' JavaScript globally
    },
    styles: {
      "bootstrap-table": ["dist/bootstrap-table.css"],
      "jquery-ui": ["themes/base/all.css"]
    } // included these styles into the build
  }
};
