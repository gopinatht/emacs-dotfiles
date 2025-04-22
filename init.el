
;; .emacs.d/init.el

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
            '("melpa" . "http://melpa.org/packages/") t)

;;(setq package-archives '(("melpa" . "https://melpa.org/packages/")
;;                         ("org" . "https://orgmode.org/elpa/")
;;                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; '(package-archive-priorities
;;   (quote
;;     (("org" . 15)
;;      ("gnu" . 10)
;;      ("melpa-stable" . 5)
;;      ("melpa" . 15))))

;; '(package-archives
;;   (quote
;;    (("gnu" . "https://elpa.gnu.org/packages/") ;
;;     ("melpa" . "https://melpa.org/packages/")
;;     ("melpa-stable" . "https://stable.melpa.org/packages/")
;;     ("org" . "https://orgmode.org/elpa/"))))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(
;;    better-defaults                 ;; Set up some better Emacs defaults
    use-package                     ;; For easy install of packages
;;    elpy                            ;; Emacs Lisp Python Environment
;;    flycheck                        ;; On the fly syntax checking
;;    py-autopep8                     ;; Run autopep8 on save
;;    blacken                         ;; Black formatting on save
    magit                           ;; Git integration
    material-theme                  ;; Theme
    )
  )

;; Scans the list in myPackages

;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

(require 'use-package)
(setq use-package-always-ensure t)

;; ===================================
;; Basic Customization
;; ===================================

(use-package org)

(use-package command-log-mode
  :config
  (global-command-log-mode t))

(use-package swiper
  :ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package doom-modeline
 :ensure t
 :init (doom-modeline-mode 1)
 :custom ((doom-modeline-height 15)))

(use-package doom-themes)
(use-package timu-macos-theme
  :ensure t
  :config
  (load-theme 'timu-macos t))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;;(when (file-directory-p "~/dev/src")
  (setq projectile-project-search-path '(("~/dev/src/github.com" . 4) ("~/dev/src/github.intuit.com" . 4)))
  (setq projectile-auto-discover t)
  (setq projectile-switch-project-action #'projectile-dired)
  (projectile-discover-projects-in-search-path))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; (setq inhibit-startup-message t)    ;; Hide the startup message
;; (load-theme 'material t)
;; Load material theme
(column-number-mode)
(global-display-line-numbers-mode)
;;(global-linum-mode t)               ;; Enable line numbers globally

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


;; ====================================
;; Development Setup
;; ====================================
;; Enable elpy
;;(elpy-enable)

;; Enable Flycheck
;;(when (require 'flycheck nil t)
;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable autopep8
;;(require 'py-autopep8)
;;(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(set-face-attribute 'default nil :height 200)

;; User-Defined init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons command-log-mode counsel counsel-projectile
		   doom-modeline doom-themes helpful ivy-rich magit
		   material-theme projectile rainbow-delimiters
		   timu-macos-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
