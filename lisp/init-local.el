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

(require-package 'bazel)

(provide 'init-local)

;;; init-local.el ends here
