;;; package --- Customisations for eshell.
;;; Commentary:
;;; Code:

(require 'eshell-p10k)

(with-eval-after-load 'eshell
  (setq eshell-prompt-function #'eshell-p10k-prompt-function
        eshell-prompt-regexp eshell-p10k-prompt-string))


(provide 'init-eshell)

;;; init-eshell.el ends here
