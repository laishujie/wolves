fs  = require 'fs'
yml = require 'js-yaml'

require.extensions['.yml'] = (module, filename)->
  module.exports = yml.safeLoad fs.readFileSync filename

config = require './config/config.yml'

module.exports = (grunt)->

  require('load-grunt-tasks') grunt

  grunt.initConfig

    jasmine_node:
      options:
        projectRoot: 'src'
        extensions: 'coffee'
        coffee: yes
        includeStackTrace: no
      all: ['spec/']

    coffee:
      world:
        options: {join: yes, bare: yes}
        files:
          'dist/main.js': [
            'src/main.coffee'
            'src/world/world.coffee'
            'src/world/human.coffee'
            'src/world/stranger.coffee'
            'src/world/village/villager.coffee'
            'src/world/village/*.villager.coffee'
            'extensions/**/*.coffee'
            'src/world/square.coffee'
          ],
      server:
        options: {join: yes, bare: yes}
        files:
          'dist/server.js': [
            'src/main.coffee'
            'src/bot.coffee'
            'src/server.coffee'
          ]

    locales:
      options:
        locales: config.locale.languages
        localizeMethodIdentifiers: ['translate']
        purgeLocales: yes
        csvKeyLabel: 'Original'
        csvExtraFields: []
        messageFormatLocaleFile: "#{__dirname}/node_modules/messageformat/locale/{locale}.js"
        messageFormatSharedFile: "#{__dirname}/node_modules/messageformat/lib/messageformat.include.js"

      update:
        src: ['dist/**/*.js']
        dest: 'dist/locales/{locale}/i18n.json'
      import:
        src: 'locales/**/*.csv'
        dest: 'dist/locales/{locale}/i18n.json'
      export:
        src: 'dist/locales/**/i18n.json'
        dest: 'locales/{locale}.csv'

    uglify:
      world: files: 'dist/main.js': ['dist/main.js']
      server: files: 'dist/server.js': ['dist/server.js']

  # Task Registrations
  grunt.registerTask 'build', ['coffee', 'locales:import', 'locales', 'uglify']

  grunt.registerTask 'test', ['jasmine_node']

  grunt.registerTask 'default', ['build']
