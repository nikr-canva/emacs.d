;;; init-local.el --- Local additions



;;; Commentary:
;;

;;; Code:

;;; Treemacs
(when (maybe-require-package 'treemacs)
  (require-package 'treemacs-projectile)
  (setq-default treemacs-display-current-project-exclusively t)
  (setq-default treemacs-project-follow-mode)
  (treemacs-resize-icons 10)
  (setq-default treemacs-text-scale 1)
  (setq-default treemacs-indentation 1)
  )

(with-eval-after-load 'ag
  (add-to-list 'ag-ignore-list "projectile.cache"))

(require-package 'projectile-speedbar)

;;; Bazel

(maybe-require-package 'bazel)

;;; Paradox

(when (maybe-require-package 'paradox)
  (setq-default paradox-execute-asynchronously t)
  (setq-default paradox-column-width-package 30)
  (paradox-enable))

;;; Make it not complain when opening big TAGS files
(setq large-file-warning-threshold 1200000000)

(setq desktop-restore-eager 5)

;;; jsonnet-mode
(when (require-package 'jsonnet-mode)
  (with-eval-after-load 'eglot
    (add-to-list  'eglot-server-programs
                  '(jsonnet-mode . ("jsonnet-lsp" "lsp")))
    )
  (add-hook 'jsonnet-mode-hook 'eglot-ensure))

(when (require-package 'kubernetes)
  (fset 'k8s 'kubernetes-overview))

;;; org-mode
(setq org-agenda-files (list "~/work/notes.org" "~/work/org/"))
(require 'org-protocol)
(add-to-list 'org-capture-templates
             '("cm" "chainguard migration"
               entry (file "~/work/org/projects/chainguard.org")
               "* TODO {project name}
    :PROPERTIES:
    :CREATED: %U
    :END:
    ** Problems
    - [ ]
    ** Links"
               :kill-buffer t
               :prepend t
               :empty-lines 2)
             t)

;; (with-eval-after-load 'org
;;   (when   (maybe-require-package 'org-beautify-theme)
;;     (load-theme 'org-beautify)
;;     (enable-theme 'org-beautify)))


(when (require-package 'go-mode)
  (with-eval-after-load 'eglot
    (add-to-list  'eglot-server-programs
                  '(go-mode . ("gopls" "serve")))
    )
  (add-hook 'go-mode-hook 'eglot-ensure))

;;; TRAMP for devboxes
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq tramp-terminal-type "tramp")


(defun nikr--1password-construct-query-path
    (_backend _type host user _port)
  "Construct the full entry-path for the 1password entry for HOST and USER.
Usually starting with the `auth-source-1password-vault', followed
by host and user, but with '^' replaced in the user name by '_'."
  (mapconcat #'identity
             (list auth-source-1password-vault host
                   (string-replace "^" "_" user))
             "/"))

;;; 1password integration
(when (maybe-require-package 'auth-source-1password)
  (setq auth-source-1password-vault "Employee")
  (setq auth-source-1password-construct-secret-reference
        'nikr--1password-construct-query-path )
  (auth-source-1password-enable))


;; make orderless completion style more fuzzy by default
(when (maybe-require-package 'orderless)
  (setq-default orderless-matching-styles
                '(orderless-literal orderless-regexp orderless-flex)))


(provide 'init-local)

;;; init-local.el ends here
