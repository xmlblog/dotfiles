;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; ===============================================================================
;;                                     STARTUP
;; ===============================================================================

(add-to-list 'default-frame-alist              '(fullscreen . maximized))


;; ===============================================================================
;;                                 PERSONALIZATION
;; ===============================================================================

(setq user-full-name                           "Christian Romney"
      user-mail-address                        "christian.a.romney@gmail.com"
      calendar-location-name                   "Pembroke Pines, FL"
      calendar-longitude                       -80.3432341
      calendar-latitude                        26.0170038
      confirm-kill-emacs                       nil
      calendar-week-start-day                  1
      +default-want-RET-continue-comments      nil
      enable-dir-local-variables               t
      enable-local-variables                   t)

;; ===============================================================================
;;                                    APPEARANCE
;; ===============================================================================

(setq doom-theme                     'doom-one-light
      doom-font                      (font-spec :family "Iosevka Medium" :size 20)
      fancy-splash-image             (concat doom-private-dir "cognitect.png")
      display-line-numbers-type      t)

(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

(setq-default tab-width 2)

(load! "+custom-functions") ;; load my custom functions before all other config

;; ===============================================================================
;;                                GLOBAL BEHAVIORS
;; ===============================================================================

;; move cache to private dir
(setq doom-cache-dir
      (custom/ensure-directory (expand-file-name ".local/cache/" doom-private-dir)))

;; Don't ask me when killing process buffers
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode
      kill-buffer-query-functions     (remq 'process-kill-buffer-query-function
                                            kill-buffer-query-functions))

;; -------------------------------------------------------------------------------
;;                                SMART(ER)PARENS
;; -------------------------------------------------------------------------------
;;
;; smartparens globally conflicts with many org-mode bindings
(remove-hook! 'doom-first-buffer-hook #'smartparens-global-mode)
(add-hook!    'emacs-lisp-mode-hook #'turn-on-smartparens-strict-mode)

(use-package! smartparens
  :config
  (pcase-dolist (`(,open . ,close) '(("(" . ")")
                                     ("[" . "]")
                                     ("{" . "}")))
    ;; remove all default rules
    (sp-pair open close :post-handlers nil :unless nil)
    ;; add sole exception
    (sp-pair open close :unless '(:add sp-in-string-p))))

;; -------------------------------------------------------------------------------
;;                             NAVIGATION BEHAVIOR
;; -------------------------------------------------------------------------------
;;
;; I like repeated searches to remain in the middle of the screen so I don't
;; have to scan my monitor for the place where I've landed. I can always stare
;; at the center of the screen and find my search results.
;;

(add-hook! 'isearch-mode-end-hook
           #'custom/flash-view-centered)

(defadvice isearch-forward
    (after isearch-forward-recenter activate)
  (custom/flash-view-centered))

(ad-activate 'isearch-forward)

(defadvice isearch-repeat-forward
    (after isearch-repeat-forward-recenter activate)
  (custom/flash-view-centered))

(ad-activate 'isearch-repeat-forward)

(defadvice isearch-backward
    (after isearch-backward-recenter activate)
    (custom/flash-view-centered))
(ad-activate 'isearch-backward)


(defadvice isearch-repeat-backward
    (after isearch-repeat-backward-recenter activate)
  (custom/flash-view-centered))

(ad-activate 'isearch-repeat-backward)

;; ===============================================================================
;;                              GLOBAL KEY BINDINGS
;; ===============================================================================

(map! "C-e"       #'move-end-of-line
      "C-'"       #'avy-goto-line
      "C-:"       #'avy-goto-char
      "C-x \\"    #'align-regexp
      "C-x g"     #'magit-status
      "C-x P"     #'print-buffer
      "C-x r I"   #'string-insert-rectangle
      "C-x C-h"   #'add-file-local-variable-prop-line
      "C-x M-s"   #'transpose-sexps
      "C-x M-t"   #'transpose-paragraphs
      "C-c a"     #'org-agenda
      "C-c M-t"   #'transpose-sentences
      "M-/"       #'hippie-expand
      "M-o"       #'other-window
      "M-p"       #'fill-paragraph
      "M-%"       #'anzu-query-replace
      "C-c g"     #'google-this
      "M-\\"      #'custom/delete-horizontal-space
      "M-SPC"     #'custom/just-one-space
      "<s-right>" #'sp-forward-slurp-sexp
      "<s-left>"  #'sp-forward-barf-sexp
      "C-c o w"   #'+pass/ivy
      "C-c i w"   #'pass-insert
      "C-M-%"     #'anzu-query-replace-regexp
      "C-x b"     #'ivy-switch-buffer ;; reverse these annoying defaults
      "C-x B"     #'+ivy/switch-workspace-buffer)

;; ===============================================================================
;;                           PACKAGE CUSTOMIZATION
;; ===============================================================================

(add-to-list 'auto-mode-alist (cons "\\.adoc\\'" 'adoc-mode))

;; +-----------------------------------------------------------------------------+
;; |                                   DIRED                                     |
;; +-----------------------------------------------------------------------------+
(setq insert-directory-program "/usr/local/bin/gls"
      dired-listing-switches   "-aBhl --group-directories-first")

(map! :map dired-mode-map
      "C-l" #'dired-up-directory
      "r"   #'reveal-in-osx-finder)

;; +-----------------------------------------------------------------------------+
;; |                                  Ivy                                        |
;; +-----------------------------------------------------------------------------+

(when (featurep! :completion ivy)
  (use-package! ivy
    :bind
    (("M-i"     . #'counsel-imenu)
     ("C-c M-o" . #'occur)
     ("C-s"     . #'swiper-isearch)
     ;; behave like helm to go up a level
     :map ivy-minibuffer-map
     ("C-l"     . #'ivy-backward-delete-char))))

(after! ivy
  ;; (autoload 'ivy-bibtex "ivy-bibtex" "" t)
  ;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
  ;; ignores the order of regexp tokens when searching for matching candidates.
  ;; Add something like this to your init file:
  (setq ivy-re-builders-alist
          '((ivy-bibtex . ivy--regex-ignore-order)
            (t . ivy--regex-plus))))

;; +-----------------------------------------------------------------------------+
;; |                                  Magit                                      |
;; +-----------------------------------------------------------------------------+

(setq magit-revision-show-gravatars t)
(add-hook! 'magit-mode-hook
  (lambda () (magit-delta-mode +1)))

;; +-----------------------------------------------------------------------------+
;; |                                  IRC                                        |
;; +-----------------------------------------------------------------------------+

(after! circe
  (let* ((host "irc.libera.chat")
         (user (custom/read-auth-username :host host))
         (pass (custom/read-auth-password :host host)))
    (set-irc-server! host
                     `(:tls t
                       :port 6697 ;; TLS port
                       :nick ,user
                       :sasl-username ,user
                       :sasl-password ,pass
                       :channels ("#clojure" "#emacs")))))

;; ===============================================================================
;;                   LOAD ADDITIONAL MODE-SPECIFIC CUSTOMIZATIONS
;; ===============================================================================

(load! "+org")
(load! "+clojure")
(load! "+scheme")
(load! "+cc")
