;;; init.el --- Bozhidar's Emacs configuration
;;
;; Copyright (c) 2016 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: https://github.com/bbatsov/emacs.d
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.  Nothing more, nothing less.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; update the package metadata if the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(eval-when-compile (require 'use-package))
(require 'diminish)
(require 'bind-key)

(setq use-package-verbose t)

;; Always load newest byte code
(setq load-prefer-newer t)

(setq user-full-name "Callum White"
      user-mail-address "callumw1991@gmail.com")

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst cwhitey-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p cwhitey-savefile-dir)
  (make-directory cwhitey-savefile-dir))

;; suppress warnings for redefinitions
(setq ad-redefinition-action 'accept)

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; never want the menu bar (at least on OSX anyway)
(menu-bar-mode -1)

(defun server-visit-presets ()
  "Things to run when server is hit by new emacsclient instances."
  (message "Running server-visit-presets")
  (menu-bar-mode -1))
(add-hook 'server-visit-hook 'server-visit-presets)

;; remove scroll bars
(scroll-bar-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; Set default font (only verified in OSX)
;; For other solutions see https://www.emacswiki.org/emacs/SetFonts
(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Menlo")
  (set-face-attribute 'default nil :height 140))

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; More convenient key bindings cycling buffers (hands stay on home)
(global-set-key (kbd "C-,") 'previous-buffer)
(global-set-key (kbd "C-.") 'next-buffer)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

;; extend the help commands
(define-key 'help-command (kbd "C-f") #'find-function)
(define-key 'help-command (kbd "C-k") #'find-function-on-key)
(define-key 'help-command (kbd "C-v") #'find-variable)
(define-key 'help-command (kbd "C-l") #'find-library)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; quicker movement when needed
(defun super-next-line ()
  (interactive)
  (ignore-errors (next-line 5)))

(defun super-previous-line ()
  (interactive)
  (ignore-errors (previous-line 5)))

(defun super-backward-char ()
  (interactive)
  (ignore-errors (backward-char 5)))

(defun super-forward-char ()
  (interactive)
  (ignore-errors (forward-char 5)))

(bind-keys ("C-S-n" . super-next-line)
           ("C-S-p" . super-previous-line)
           ("C-S-b" . super-backward-char)
           ("C-S-f" . super-forward-char))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package fasd
  :ensure t
  :config (global-fasd-mode 1))

(use-package zoom-frm
  :ensure t
  :bind (("C-+" . zoom-frm-in)
         ("C--" . zoom-frm-out)
         ("C-0" . zoom-frm-unzoom)
         ("C-x C-+" . text-scale-increase)
         ("C-x C--" . text-scale-decrease)
         ("C-x C-0" . text-scale-adjust)))

;; themes
(use-package ample-theme
  :ensure t
  :config (load-theme 'ample t))

;; highlight the current line
(global-hl-line-mode +1)

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char))
  :config
  (setq avy-background t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package ag
  :ensure t
  :defer t)

(use-package pt
  :ensure t
  :defer t)

(use-package projectile
  :ensure t
  :bind ("s-p" . projectile-command-map)
  :config
  (projectile-global-mode +1))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package paren
  :config (show-paren-mode +1))

(use-package abbrev
  :diminish 'abbrev-mode
  :config 
  (setq save-abbrevs 'silently)
  (setq-default abbrev-mode t))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" cwhitey-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

;; save minibuffer histories and defined savehist-additional-variables
(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" cwhitey-savefile-dir))
  (savehist-mode +1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" cwhitey-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package anzu
  :ensure t
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config (global-anzu-mode))

;; investigate easy-kill's easy-mark
(use-package easy-kill
  :ensure t
  :defer t
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package move-text
  :ensure t
  :bind (([(meta shift up)] . move-text-up)
         ([(meta shift down)] . move-text-down)))

(use-package rainbow-delimiters
  :ensure t
  :defer t)

(use-package rainbow-mode
  :ensure t
  :diminish 'rainbow-mode
  :commands (rainbow-mode)
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package whitespace
  :disabled t
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package crux
  :ensure t
  :commands (crux-start-or-switch-to)
  :bind (("C-c o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-M-z" . crux-indent-defun)
         ("C-c u" . crux-view-url)
         ("C-c e" . crux-eval-and-replace)
         ("C-c w" . crux-swap-windows)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-c s" . crux-ispell-word-then-abbrev)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; neaten this up
(use-package lisp-mode
  :defer t
  :config
  (defun cal-visit-ielm ()
    "Switch to default `ielm' buffer.
Start `ielm' if it's not already running."
    (interactive)
    (crux-start-or-switch-to 'ielm "*ielm*"))

  (add-hook 'lisp-interaction-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'cal-visit-ielm)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'eval-defun)
  (define-key emacs-lisp-mode-map (kbd "C-c C-b") #'eval-buffer)
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode))

(use-package ielm
  :defer t
  :config
  (add-hook 'ielm-mode-hook #'eldoc-mode)
  (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))

(use-package elisp-slime-nav
  :ensure t
  :defer t
  :config
  (add-hook 'emacs-lisp-mode-hook #'elisp-slime-nav-mode)
  (add-hook 'ielm-mode-hook #'elisp-slime-nav-mode))

(use-package shell-script-mode
  :mode (("\\zshrc\\'" . shell-script-mode)
         ("\\zshenv\\'" . shell-script-mode)
         ("\\zpreztorc\\'" . shell-script-mode)
         ("\\zprofile\\'" . shell-script-mode)
         ("\\zlogin\\'" . shell-script-mode)
         ("\\zlogout\\'" . shell-script-mode)))

;; TODO: Smartparens?
(use-package paredit
  :ensure t
  :diminish 'paredit-mode
  :config
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  ;; enable in the *scratch* buffer
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode) 
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode))

(use-package web-mode
  :ensure t
  :defer t)

(use-package json-mode
  :ensure t
  :defer t)

;; TODO: Sort JS stuff out
(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.pac\\'" . js2-mode))
  :interpreter "node"
  :config
  (add-hook 'js2-mode-hook (lambda () (setq mode-name "JS2"))))

(use-package jade-mode
  :ensure t
  :defer t)

(use-package ruby-mode
  :defer t
  :init
  (add-hook 'ruby-mode-hook #'subword-mode) 
  :config 
  (use-package inf-ruby
    :ensure t
    :init (add-hook 'ruby-mode-hook #'inf-ruby-minor-mode))
  (use-package robe
    :ensure t
    :init (add-hook 'ruby-mode-hook #'robe-mode)))

(use-package chruby
  :ensure t
  :defer t
  :config (chruby "ruby 2.2.3"))

(use-package bundler
  :ensure t
  :commands (bundle-open bundle-console bundle-install bundle-update bundle-check))

(use-package projectile-rails
  :ensure t
  :bind (:map projectile-rails-mode-map
              ("s-r m" . projectile-rails-find-model)
              ("s-r c" . projectile-rails-find-controller)
              ("s-r v" . projectile-rails-find-view))
  :config
  (add-hook 'projectile-mode-hook 'projectile-rails-on))

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

;; Shortcut for calling user/reset when using the reloaded workflow
;; https://github.com/stuartsierra/reloaded
(defun cider-repl-reset ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset)")
    (cider-repl-return)))

(use-package cider
  :ensure t
  :bind ("C-c r" . cider-repl-reset)
  :config
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

(use-package erlang
  :ensure t
  :commands 'erlang-mode)

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package yaml-mode
  :ensure t
  :defer t)

(use-package gitconfig-mode
  :ensure t
  :defer t
  :config (add-hook 'gitconfig-mode-hook
                    (lambda ()
                      (setf indent-tabs-mode nil
                            tab-width 4))))

;; HELM HELM HELM
(use-package helm
  :ensure t
  :bind-keymap (("C-c h" . helm-command-prefix))
  :bind (("M-x" . helm-M-x)
         ("C-x C-m" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-b". helm-buffers-list)
         ("C-x C-f" . helm-find-files)
         ("C-h r" . helm-info-emacs)
         :map helm-command-map
         ("o" . helm-occur)
         ("g" . helm-do-grep)
         ("SPC" . helm-all-mark-rings))
  :init
  (setq helm-split-window-in-side-p           t
        helm-buffers-fuzzy-matching           t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-ff-file-name-history-use-recentf t)
  :config
  (require 'helm-config)
  (require 'helm-eshell))

(use-package helm-descbinds
  :ensure t
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))

(use-package helm-ag
  :ensure t
  :defer t)

(use-package helm-projectile
  :ensure t
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package company
  :ensure t
  :commands (company-mode)
  :config (add-hook 'prog-mode-hook #'company-mode))

(use-package zop-to-char
  :ensure t
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

(use-package flyspell
  :ensure t
  :config
  (when (eq system-type 'windows-nt)
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/"))
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; save emacs buffers when they lose focus
(use-package super-save
  :ensure t
  :diminish 'super-save-mode
  :config
  (super-save-mode +1))

(use-package aggressive-indent
  :ensure t
  :config
  (global-aggressive-indent-mode +1)
  (add-to-list 'aggressive-indent-excluded-modes 'jade-mode))

;; highlight uncommitted changes on left side of buffer
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package which-key
  :ensure t
  :config
  (which-key-mode +1))

(use-package undo-tree
  :ensure t
  :bind (("C-/" . undo-tree-undo)
         ("C-?" . undo-tree-redo)
         ("C-x u" . undo-tree-visualize))
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t))

;; goto edit history locations without changing anything
(use-package goto-chg
  :ensure t
  :bind (("C-c ," . goto-last-change)
         ("C-c ." . goto-last-change-reverse)))

;; split using last buffer instead of current
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))

(bind-key "C-x 2" 'vsplit-last-buffer)
(bind-key "C-x 3" 'hsplit-last-buffer)

(global-unset-key (kbd "M-<down-mouse-1>"))
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-c m t" . mc/mark-all-like-this)
   ("C-c m m" . mc/mark-all-like-this-dwim)
   ("C-c m l" . mc/edit-lines)
   ("C-c m e" . mc/edit-ends-of-lines)
   ("C-c m a" . mc/edit-beginnings-of-lines)
   ("C-c m n" . mc/mark-next-like-this)
   ("C-c m p" . mc/mark-previous-like-this)
   ("C-c m s" . mc/mark-sgml-tag-pair)
   ("C-c m d" . mc/mark-all-like-this-in-defun)
   ("M-<mouse-1>" . mc/add-cursor-on-click)))

;; Windows stuff
(when (eq system-type 'windows-nt)
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super) ; Left Windows key

  (setq w32-pass-rwindow-to-system nil)
  (setq w32-rwindow-modifier 'super) ; Right Windows key

  (setq w32-pass-apps-to-system nil)
  (setq w32-apps-modifier 'hyper) ; Menu/App key

  (set-frame-font "Source Code Pro 12")
  (add-to-list 'exec-path "C:/Program Files/Git/bin")
  (add-to-list 'exec-path "C:/Program Files/Git/mingw64/bin")
  (setenv "PATH" (concat "C:/Program Files/Git/bin;" "C:/Program Files/Git/mingw64/bin;" (getenv "PATH")))
  ;; needed for arc-mode
  (add-to-list 'exec-path "C:/Program Files/7-Zip"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" default)))
 '(foreground-color nil)
 '(package-selected-packages
   (quote
    (cask-mode buttercup rainbow-mode ztree zop-to-char zenburn-theme yasnippet yaml-mode which-key use-package super-save smex rainbow-delimiters pt projectile paredit noflet multiple-cursors move-text markdown-mode magit inflections inf-ruby inf-clojure imenu-anywhere flycheck expand-region exec-path-from-shell evil erlang elisp-slime-nav edn easy-kill crux company cider avy anzu aggressive-indent ag)))
 '(safe-local-variable-values
   (quote
    ((checkdoc-package-keywords-flag)
     (eval when
           (require
            (quote rainbow-mode)
            nil t)
           (rainbow-mode 1))
     (bug-reference-bug-regexp . "#\\(?2:[[:digit:]]+\\)")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
