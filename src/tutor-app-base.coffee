ko = require 'knockout'
i18n = require 'i18next-ko'
pagejs = require 'page'

###
config:
{
  mainElement: '#mainElementSelector',
  translations:
    en: require '../path/to/locale',
}
###


class TutorAppBase
  constructor: (@_config) ->
    @page = ko.observable()
    @pageParams = ko.observable {}
    @pageRequiresLogin = ko.observable true
    @path = ko.observable ''

    i18n.init @_config.translations, 'en', ko
    @language = ko.observable 'en'
    @language.subscribe (v) -> i18n.setLanguage(v)

    @user = ko.observable()

  goto: (path, replace) ->
    mainElement = document.querySelector(@_config.mainElement)?.firstChild
    if mainElement
      pageComponent = ko.dataFor mainElement
      if pageComponent and pageComponent.onBeforeHide
        if pageComponent.onBeforeHide() is false
          return

    path or= ''
    path = "/#{path}" if path.indexOf('/') != 0

    if path isnt @path()
      @_config.pagejs path


  registerPage: (path, options, fn) ->
    if !fn
      fn = options
      options = {}

    @_config.pagejs.page path, (ctx) =>
      @path ctx.path
      @pageParams ctx.params
      @pageRequiresLogin options.loginRequired isnt false
      @page options.component

  isActive: (path) -> @path().indexOf(path) == 0

module.exports = TutorAppBase
