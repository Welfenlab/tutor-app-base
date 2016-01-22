// Generated by CoffeeScript 1.10.0
(function() {
  var _, i18n, pagejs;

  i18n = require('i18next-ko');

  pagejs = require('page');

  _ = require('lodash');


  /*
  config:
  {
    mainElement: '#mainElementSelector',
    translations:
      en: require '../path/to/locale',
  }
   */

  module.exports = function($, ko) {
    var TutorAppBase;
    TutorAppBase = (function() {
      function TutorAppBase(_config) {
        var l, ref, t, translations;
        this._config = _config;
        translations = {};
        this.availableLanguages = [];
        ref = this._config.translations;
        for (l in ref) {
          t = ref[l];
          translations[l] = {
            translation: t
          };
          this.availableLanguages.push(l);
        }
        i18n.init(translations, 'en', ko);
        this.page = ko.observable();
        this.pageParams = ko.observable({});
        this.pageRequiresLogin = ko.observable(true);
        this.path = ko.observable('');
        this.user = ko.observable();
        $((function(_this) {
          return function() {
            var app;
            app = _this;
            $(document).on('click', 'a', function(e) {
              if ($(this).attr('href') && !/^https?:\/\//i.test($(this).attr('href'))) {
                e.preventDefault();
                app.goto($(this).attr('href'));
                return false;
              }
            });
            pagejs({
              hashbang: false,
              click: false,
              popstate: true
            });
            _this.language = ko.observable('en');
            _this.language.subscribe(function(v) {
              return i18n.setLanguage(v);
            });
            _this.availableLanguages = _.keys(_this._config.translations);
            return i18n.setLanguage('en');
          };
        })(this));
      }

      TutorAppBase.prototype.boot = function() {
        return ko.applyBindings(app);
      };

      TutorAppBase.prototype.goto = function(path, force) {
        var mainElement, pageComponent, ref;
        mainElement = (ref = document.querySelector(this._config.mainElement)) != null ? ref.firstChild : void 0;
        if (mainElement) {
          pageComponent = ko.dataFor(mainElement);
          if (pageComponent && pageComponent.onBeforeHide) {
            if (pageComponent.onBeforeHide() === false) {
              return;
            }
          }
        }
        path || (path = '');
        if (path.indexOf('/') !== 0) {
          path = "/" + path;
        }
        if (force || path !== this.path()) {
          return pagejs(path);
        }
      };

      TutorAppBase.prototype.route = function(path, options) {
        if ((path != null) && (options != null)) {
          return pagejs(path, (function(_this) {
            return function(ctx) {
              _this.path(ctx.path);
              if (typeof options === 'function') {
                return options(ctx);
              } else {
                _this.pageParams(ctx.params);
                _this.pageRequiresLogin(options.loginRequired !== false);
                return _this.page(options.component);
              }
            };
          })(this));
        }
      };

      TutorAppBase.prototype.isActive = function(path) {
        return this.path().indexOf(path) === 0;
      };

      return TutorAppBase;

    })();
    return TutorAppBase;
  };

}).call(this);
