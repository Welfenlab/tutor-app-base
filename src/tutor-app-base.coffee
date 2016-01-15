ko = require 'knockout'
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


class TutorAppBase
  constructor: (@_config) ->
    i18n.init @_config.translations, 'en', ko
    @page = ko.observable()
    @pageParams = ko.observable {}
    @pageRequiresLogin = ko.observable true
    @path = ko.observable ''

    @user = ko.observable()

  onload: ->
    @language = ko.observable 'en'
    @language.subscribe (v) -> i18n.setLanguage(v)
    @availableLanguages = _.keys @_config.translations
    i18n.setLanguage('en')

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


  register: (path, options) ->
    @_config.pagejs path, (ctx) =>
      @path ctx.path

      if typeof options == 'function'
        options(ctx)
      else
        @pageParams ctx.params
        @pageRequiresLogin options.loginRequired isnt false
        @page options.component

  isActive: (path) -> @path().indexOf(path) == 0

module.exports = TutorAppBase
