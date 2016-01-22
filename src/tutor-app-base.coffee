i18n = require 'i18next-ko'
pagejs = require 'page'
_ = require 'lodash'

###
config:
{
  mainElement: '#mainElementSelector',
  translations:
    en: require '../path/to/locale',
}
###

module.exports = ($, ko) ->
  class TutorAppBase
    constructor: (@_config) ->
      #transform translation config into the format that i18next-ko needs
      translations = {}
      @availableLanguages = []
      for l, t of @_config.translations
        translations[l] = translation: t
        @availableLanguages.push l
      i18n.init translations, 'en', ko

      @page = ko.observable()
      @pageParams = ko.observable {}
      @pageRequiresLogin = ko.observable true
      @path = ko.observable ''

      @user = ko.observable()

      $ =>
        app = this
        $(document).on 'click', 'a', (e) ->
          if $(this).attr('href') and not /^https?:\/\//i.test($(this).attr('href'))
            e.preventDefault()
            app.goto($(this).attr('href'))
            return false

        #$(window).on 'popstate', (e) ->
        #  if e.originalEvent.state
        #    app.goto e.originalEvent.state.path, e.originalEvent.state

        pagejs(hashbang: false, click: false, popstate: true) #handlers don't work, we do it on our own below
        @language = ko.observable 'en'
        @language.subscribe (v) -> i18n.setLanguage(v)
        @availableLanguages = _.keys @_config.translations
        i18n.setLanguage('en')

    boot: ->
      ko.applyBindings app

    goto: (path, force) ->
      mainElement = document.querySelector(@_config.mainElement)?.firstChild
      if mainElement
        pageComponent = ko.dataFor mainElement
        if pageComponent and pageComponent.onBeforeHide
          if pageComponent.onBeforeHide() is false
            return

      path or= ''
      path = "/#{path}" if path.indexOf('/') != 0

      if force or path isnt @path()
        pagejs path


    route: (path, options) ->
      if path? and options?
        pagejs path, (ctx) =>
          @path ctx.path

          if typeof options == 'function'
            options(ctx)
          else
            @pageParams ctx.params
            @pageRequiresLogin options.loginRequired isnt false
            @page options.component

    isActive: (path) -> @path().indexOf(path) == 0

  return TutorAppBase
