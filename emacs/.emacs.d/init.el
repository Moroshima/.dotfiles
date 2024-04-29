(setq auto-save-default nil)  ; stop creating #autosave# files
(setq make-backup-files nil)  ; stop creating backup~ files

;; modified from https://github.com/doomemacs/doomemacs/blob/9620bb45ac4cd7b0274c497b2d9d93c4ad9364ee/lisp/doom-start.el#L139C1-L150C1
;; Contrary to what many Emacs users have in their configs, you don't need more
;; than this to make UTF-8 the default coding system:
(set-language-environment "UTF-8")
;; ...but `set-language-environment' also sets `default-input-method', which is
;; a step too opinionated.
(setq default-input-method nil)
;; I use macOS, so just set it.
(setq selection-coding-system 'utf-8)

(require 'package)
(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))
(package-initialize)

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
	      ("C-c C-e" . markdown-do)))

(use-package sis
  :ensure t
  ;; :hook
  ;; enable the /context/ and /inline region/ mode for specific buffers
  ;; (((text-mode prog-mode) . sis-context-mode)
  ;;  ((text-mode prog-mode) . sis-inline-mode))

  :config
  ;; For MacOS
  (sis-ism-lazyman-config

   ;; English input source may be: "ABC", "US" or another one.
   "com.apple.keylayout.ABC"
   ;; "com.apple.keylayout.US"

   ;; Other language input source: "rime", "sogou" or another one.
   ;; "im.rime.inputmethod.Squirrel.Rime"
   ;; "com.sogou.inputmethod.sogou.pinyin"
   "com.apple.inputmethod.SCIM.ITABC"
   )

  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
 )

(use-package vterm
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(markdown-mode sis vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
