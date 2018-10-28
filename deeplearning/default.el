(load "/usr/share/emacs/site-lisp/installEmacsPackages")

;; python virtual env setup
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support
(setq venv-location "/opt/")
(setq python-environment-directory venv-location)
(venv-workon "conda")

;; jedi setup
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; python-docstring setup
(require 'python-docstring)
(add-hook 'python-mode-hook (lambda () (python-docstring-mode t)))

;; python environmnt information in the mode line
(setq-default mode-line-format (cons '(:exec venv-current-name) mode-line-format))

;; no splash screen
(setq inhibit-splash-screen t)

;; remove menubar
(menu-bar-mode 0)

;; remove toolbar
(tool-bar-mode -1)

;; remove scrollbar
(scroll-bar-mode -1)

;; column number
(column-number-mode 1)

;; mini buffer completion
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

;; visual beeping
(setq visible-bell t)

;; show matching paren
(show-paren-mode 1)

;; Turn off blinking cursor
(blink-cursor-mode nil)

;; Enable font lock mode globally
(global-font-lock-mode 1)

;; pytest setup
(require 'pytest)
(add-hook 'python-mode-hook
	  (lambda ()
	    (local-set-key "\C-ta" 'pytest-all)
	    (local-set-key "\C-tm" 'pytest-module)
	    (local-set-key "\C-t." 'pytest-one)
	    (local-set-key "\C-td" 'pytest-directory)
	    (local-set-key "\C-tpa" 'pytest-pdb-all)
	    (local-set-key "\C-tpm" 'pytest-pdb-module)
	    (local-set-key "\C-tp." 'pytest-pdb-one)))

;; flycheck
(require 'flycheck-mypy)
(add-hook 'python-mode-hook 'flycheck-mode)
(with-eval-after-load 'flycheck
  (flycheck-add-next-checker 'python-flake8 '(t . python-mypy) t))

;; ox-reveal
(require 'ox-reveal)

;; sphinx mode
(add-hook 'python-mode-hook (lambda ()
			      (require 'sphinx-doc)
			      (sphinx-doc-mode t)))

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
