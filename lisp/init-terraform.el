;;; init-terraform.el --- Work with Terraform configurations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Terraform
(when
    (maybe-require-package 'terraform-mode)
  ;; TODO: find/write a replacement for company-terraform
  (with-eval-after-load 'terraform-mode
    ;; I find formatters based on "reformatter" to be more reliable
    ;; so I redefine `terraform-format-on-save-mode' here.
    (when
        (maybe-require-package 'reformatter)
      (reformatter-define terraform-format
        :program "terraform" :args
        '("fmt" "-")))
    (when
        (maybe-require-package 'company-terraform)
      (company-terraform-init)
      (add-hook 'terraform-mode-hook
                (company-mode t)))
    (when
        (maybe-require-package 'eglot)
      (add-hook 'jsonnet-mode-hook 'eglot-ensure))
    )
  )
(provide 'init-terraform)
;;; init-terraform.el ends here
