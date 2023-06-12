;;; init-projectile.el --- Use Projectile for navigation within projects -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'projectile)
  (add-hook 'after-init-hook 'projectile-mode)

  ;; Shorter modeline
  (setq-default projectile-mode-line-prefix " Proj")
  (setq projectile-enable-caching t)
  (when (executable-find "rg")
    (setq-default projectile-generic-command "rg --files --hidden -0"))

  (with-eval-after-load 'projectile
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

  (maybe-require-package 'ibuffer-projectile)
  (defun projectile-vc-root-dir (dir)
    "Retrieve the root directory of the project at DIR using `vc-root-dir'."
    (let ((default-directory dir))
      (vc-root-dir)))

  (setq projectile-project-root-functions '(projectile-vc-root-dir
                                            projectile-root-local
                                            projectile-root-marked
                                            projectile-root-bottom-up)))


(provide 'init-projectile)
;;; init-projectile.el ends here
