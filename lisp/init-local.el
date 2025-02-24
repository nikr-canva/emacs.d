;;; init-local.el --- Local additions



;;; Commentary:
;;

;;; Code:

;;; Treemacs
(when (maybe-require-package 'treemacs)
  (require-package 'treemacs-projectile)
  (setq-default treemacs-display-current-project-exclusively t)
  (setq-default treemacs-project-follow-mode)
  (treemacs-resize-icons 12)
  )

(with-eval-after-load 'ag
  (add-to-list 'ag-ignore-list "projectile.cache"))

;;; Bazel

(maybe-require-package 'bazel)

;;; Paradox

(when (maybe-require-package 'paradox)
  (setq-default paradox-execute-asynchronously t)
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
(setq org-agenda-files (list "~/work/notes.org"))
(when (require-package 'go-mode)
  (with-eval-after-load 'eglot
    (add-to-list  'eglot-server-programs
                  '(go-mode . ("gopls" "serve")))
    )
  (add-hook 'go-mode-hook 'eglot-ensure))


(provide 'init-local)

;;; init-local.el ends here
