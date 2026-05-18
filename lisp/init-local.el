;;; init-local.el --- Local additions



;;; Commentary:
;;

;;; Code:

;;; <OPTION> as SUPER (S-*).
(when *is-a-mac*
  (setq mac-option-modifier 'super))

(setq-default fill-column 100)

;;; We need some extra env vars so git works properly.
(require-package 'exec-path-from-shell)

(with-eval-after-load 'exec-path-from-shell
  (dolist (var '("CODER_AGENT_URL" "CODER_AGENT_AUTH" "CODER_AGENT_TOKEN" "GIT_ASKPASS" "GIT_SSH_COMMAND"))
    (add-to-list 'exec-path-from-shell-variables var)))
(exec-path-from-shell-initialize)

;;; Treemacs
(when (maybe-require-package 'treemacs)
  (require-package 'treemacs-projectile)
  (setq-default treemacs-display-current-project-exclusively t)
  (setq-default treemacs-project-follow-mode)
  (treemacs-resize-icons 10)
  (setq-default treemacs-text-scale 1)
  (setq-default treemacs-indentation 1))

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
  (add-hook 'jsonnet-mode-hook 'eglot-ensure))

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs '(jsonnet-mode . ("jsonnet-lsp" "lsp"))))

(when (require-package 'kubernetes)
  (fset 'k8s 'kubernetes-overview))

;;; org-mode
(setq org-agenda-files (list "~/work/notes.org" "~/work/org/" "~/work/nikr/org/"))
(require 'org-protocol)
(add-to-list 'org-capture-templates '("l" "Link" entry (file+olp+datetree "~/work/notes.org" "Links" ) "Link: %a\n) "))
(add-to-list 'org-capture-templates '("m" "meeting notes" entry (file+olp+datetree "~/work/org/meetings.org")
                                      "* With %^{ATTENDEES} about %^{TOPIC} :%^{TYPE|1on1|handover|}:
:PROPERTIES:
:ATTENDEES: %\\1
:TOPIC: %\\2
:TYPE: %\\3
:END:
%?"  :jump-to-captured t))

;; (with-eval-after-load 'org
;;   (when   (maybe-require-package 'org-beautify-theme)
;;     (load-theme 'org-beautify)
;;     (enable-theme 'org-beautify)))


(when (require-package 'go-mode)
  (require-package 'eglot)
  (with-eval-after-load 'eglot
    (add-to-list
     'eglot-server-programs '(go-mode . ("gopls" "serve"))))
  (add-hook 'go-mode-hook 'eglot-ensure)
  (with-eval-after-load 'flymake-flycheck
    (add-to-list 'flycheck-disabled-checkers 'go-gofmt))
  )

;;; TRAMP for devboxes
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq tramp-terminal-type "tramp")


(defun nikr--1password-construct-query-path
    (_backend _type host user _port)
  "Construct the full entry-path for the 1password entry for HOST and USER.
Usually starting with the `auth-source-1password-vault', followed
by host and user, but with '^' replaced in the user name by '_'.
This is particularly so that Emacs forge will work."
  (mapconcat #'identity
             (list
              auth-source-1password-vault
              host
              (string-replace "^" "_" user))
             "/"))

;;; 1password integration
(when (maybe-require-package 'auth-source-1password)
  (setq auth-source-1password-vault "Employee")
  (setq auth-source-1password-construct-secret-reference
        'nikr--1password-construct-query-path)
  (auth-source-1password-enable))


;; make orderless completion style more fuzzy by default
(when (maybe-require-package 'orderless)
  (setq-default orderless-matching-styles
                '(orderless-literal orderless-regexp orderless-flex)))

;; autoformat for lisp files. mainly this one.
(when (maybe-require-package 'elisp-autofmt)
  (add-hook 'emacs-lisp-mode-hook 'elisp-autofmt-mode))

(require-package 'systemd)


(when (maybe-require-package 'smart-mode-line)
  ;; (if (maybe-require-package 'smart-mode-line-powerline-theme
  ;;    (setq sml/theme 'smart-mode-line-powerline)
  (setq sml/theme 'dark)
  ;;)
  (sml/setup))

(when (require-package 'ai-code)
  (require-package 'vterm)
  ;; use the otter wrapper that authenticates properly and has MCPs set up already.
  (setq ai-code-claude-code-program  "otter")
  (setq ai-code-claude-code-program-switches '( "claude-code" ))
  (setq ai-code-backends-infra-terminal-backend 'vterm)
  (global-set-key (kbd "C-c C-i") #'ai-code-menu)
  (ai-code-prompt-filepath-completion-mode 1)
  ;; (with-eval-after-load 'magit
  ;;   (ai-code-magit-setup-transients))
  (setq ai-code-notifications-enabled t)
  (setq ai-code-notifications-show-on-response t))

(with-eval-after-load 'ai-code
  (ai-code-set-backend "claude-code.el"))

;; This claude-code-ide seems to be the one that has the scrolling issue.
;; (when (use-package claude-code-ide
;;         :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
;;         :bind ("C-c i" . claude-code-ide-menu) ; Set your favorite keybinding
;;         :config
;;         (claude-code-ide-emacs-tools-setup))
;;   (setq claude-code-ide-cli-path "otter")
;;   (setq claude-code-ide-cli-extra-flags "claude-code")
;;   (setq claude-code-ide-window-width 300)
;;   ;; (global-set-key (kbd "C-c i") #'claude-code-ide-menu)
;;   )


;; (with-eval-after-load 'claude-code-ide (claude-code-ide-emacs-tools-setup))

(when (use-package mcp-server
        :vc (:url "https://github.com/rhblind/emacs-mcp-server" :rev :newest)
        :config (add-hook 'emacs-startup-hook #'mcp-server-start-unix)
        )
  (setq mcp-server-emacs-tools-enabled 'all)
  (setq mcp-server-security-prompt-for-permissions t)
  (setq mcp-server-security-sensitive-file-patterns
        '("~/.authinfo*" "~/.netrc*" "~/.ssh/" "~/.gnupg/"))
  )

(defun mb/forge-browse-after-create-pr (value headers status req)
  (if-let ((url (assoc 'html_url value)))
      (browse-url (cdr url))))


(when (maybe-require-package 'forge)
  (add-hook 'forge-post-submit-callback 'mb/forge-browse-after-create-pr)
  (add-hook 'forge-post-mode-hook (lambda () (set-fill-column 72)))
  (setq-default forge-pull-notifications "Pull notifications"))

(when (maybe-require-package 'org-alert)
  (when (eq system-type 'darwin)
    (setq-default alert-default-style 'osx-notifier)))

;; terraform
(when (require-package 'terraform-mode)
  (when (maybe-require-package 'company-terraform)
    (company-terraform-init)
    (add-hook 'terraform-mode-hook
              (company-mode t)))
  (when (maybe-require-package 'eglot)
    (add-hook 'terraform-mode-hook 'eglot-ensure)))



(provide 'init-local)

;;; init-local.el ends here
