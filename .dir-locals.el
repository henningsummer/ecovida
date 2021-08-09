;;; .dir-locals.el --- Ecovida changes to use emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Otávio Schwanck dos Santos

;; Author: Otávio Schwanck dos Santos <otavio.schwanck@grafeno.digital>
;; Keywords: lisp, ecovida

((nil . ((eval . (setq projectile-rails-custom-server-command "bundle exec rails server"))
         (eval . (setq flycheck-disabled-checkers "ruby-rubocop ruby-reek"))
         (eval . (setq rails-routes-search-command "RUBYOPT=-W0 rake routes"))
         )))
