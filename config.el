;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Riley Levy"
      user-mail-address "rileylevy95@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font "Fira Mono-12")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'zenburn)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.



(use-package! lilypond-mode
  :defer t
  :mode ("\\.ly\\'" . LilyPond-mode))


(use-package! aggressive-indent-mode
  :hook '(lisp-mode
          common-lisp-mode
          emacs-lisp-mode
          scheme-mode
          clojure-mode))
;;;  https://github.com/Malabarba/aggressive-indent-mode/issues/137
;;;  fixes selecting deleted buffer error?
(after! aggressive-indent-mode
  (defun aggressive-indent--indent-if-changed (buffer)
    "Indent any region that changed in BUFFER in the last command loop."
    (if (not (buffer-live-p buffer))
        (and aggressive-indent--idle-timer
             (cancel-timer aggressive-indent--idle-timer))
      (with-current-buffer buffer
        (when (and aggressive-indent-mode aggressive-indent--changed-list)
          (save-excursion
            (save-selected-window
              (aggressive-indent--while-no-input
                (aggressive-indent--proccess-changed-list-and-indent))))
          (when (timerp aggressive-indent--idle-timer)
            (cancel-timer aggressive-indent--idle-timer)))))))

(map! :leader :desc "M-x" "SPC" #'execute-extended-command)

(setq dired-omit-files "^\\.?#\\|^\\.$\\|^.DS_Store\\'\\|^.project\\(?:ile\\)?\\'\\|^.\\(svn\\|git\\)\\'\\|^.ccls-cache\\'\\|\\(?:\\.js\\)?\\.meta\\'\\|\\.\\(?:elc\\|o\\|pyo\\|swp\\|class\\)\\'")

(after! highlight-indent-guides
  (setf highlight-indent-guides-responsive t))


(after! lispyville
  (map! :map lispyville-mode-map
        :i "DEL" #'lispy-backward-delete
        :i "{" #'lispy-braces
        :i "[" #'lispy-brackets
        :i "(" #'lispy-parens
        :n "(" #'lispyville-wrap-round))
