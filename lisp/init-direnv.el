;;; init-direnv.el --- Integrate with direnv -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'envrc)
  (with-eval-after-load 'envrc
    (define-key envrc-mode-map (kbd "C-c e") 'envrc-command-map)

    ;; By default direnv blocks Emacs until it finishes; cap the wait so a
    ;; slow or hung direnv can't freeze the UI.
    (setq envrc-async 5)

    ;; Vertico builds a backtrace buffer from inside the minibuffer when a
    ;; completion function errors; enabling envrc there runs direnv
    ;; synchronously in the middle of completion.
    (define-advice envrc-global-mode-enable-in-buffer
        (:around (orig &rest args) skip-backtrace-buffers)
      (unless (derived-mode-p 'backtrace-mode)
        (apply orig args))))
  (add-hook 'after-init-hook 'envrc-global-mode))

(provide 'init-direnv)

;;; init-direnv.el ends here
