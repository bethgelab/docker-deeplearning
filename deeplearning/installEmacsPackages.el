(require 'package)
(setq package-user-dir "/usr/share/emacs/site-lisp/elpa")

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq jpk-packages
      '(
	pallet
	org
	org-plus-contrib
	ox-reveal
	jedi
	virtualenvwrapper
	magit
	pytest
	flycheck
	swiper
	ivy
	counsel
	python-docstring
	flycheck-mypy
	sphinx-doc
	yaml-mode
	yasnippet
	))

;; install any packages in jpk-packages, if they are not installed already
(let ((refreshed nil))
  (when (not package-archive-contents)
    (package-refresh-contents)
    (setq refreshed t))
  (dolist (pkg jpk-packages)
    (when (and (not (package-installed-p pkg))
	       (assoc pkg package-archive-contents))
      (unless refreshed
	(package-refresh-contents)
	(setq refreshed t))
      (package-install pkg))))
