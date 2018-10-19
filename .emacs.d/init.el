;; setup package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; add to load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; hide welcome/startup screens
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)

;; set initial frame size
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; indent c switch cases
(c-set-offset 'case-label '+)

;; allow directional window navigation
(windmove-default-keybindings)
(define-key global-map (kbd "M-h") 'windmove-left)
(define-key global-map (kbd "M-j") 'windmove-down)
(define-key global-map (kbd "M-k") 'windmove-up)
(define-key global-map (kbd "M-l") 'windmove-right)

;; set default c offset to 2 spaces
(setq-default c-basic-offset 2)

;; solidity mode
(require 'solidity-mode)

;; set default solidity mode offset to 4 spaces
(add-hook 'solidity-mode-hook
	  (lambda () (setq c-basic-offset 4)))

;; bind browse-kill-ring to M-y
(browse-kill-ring-default-keybindings)

;; enable easy use of multiple terminals at once (ignore warning)
(require 'multi-term)
(defalias 'term 'multi-term)

;; Make multi-term compatible with line mode
(add-hook 'term-mode-hook
	  (lambda () (setq truncate-lines t)))
(eval-after-load "multi-term"
  '(progn
     (add-to-list 'term-bind-key-alist '("C-c C-j" . term-line-mode))
     (add-to-list 'term-bind-key-alist '("M-DEL" . term-send-backward-kill-word))
     (add-to-list 'term-bind-key-alist '("C-h" . term-send-backspace))
     ))

;; M-x customize-face changes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-begin-regexp "begin\\b\\|If\\b\\|For\\b\\|Procedure\\b\\|\\[")
 '(LaTeX-end-regexp "end\\b\\|EndIf\\b\\|EndFor\\b\\|EndProcedure\\b\\|\\]")
 '(LaTeX-indent-environment-list
   (quote
    (("verbatim" current-indentation)
     ("verbatim*" current-indentation)
     ("tabular" LaTeX-indent-tabular)
     ("tabular*" LaTeX-indent-tabular)
     ("align" LaTeX-indent-tabular)
     ("align*" LaTeX-indent-tabular)
     ("array" LaTeX-indent-tabular)
     ("eqnarray" LaTeX-indent-tabular)
     ("eqnarray*" LaTeX-indent-tabular)
     ("displaymath")
     ("equation")
     ("equation*")
     ("picture")
     ("tabbing")
     ("algorithmic")
     ("tikzpicture")
     ("scope")
     ("algpseudocode"))))
 '(LaTeX-paragraph-commands nil)
 '(ansi-color-names-vector
   ["#222222" "#a85454" "#65a854" "#8d995c" "#5476a8" "#9754a8" "#54a8a8" "#969696"])
 '(custom-safe-themes
   (quote
    ("cedd3b4295ac0a41ef48376e16b4745c25fa8e7b4f706173083f16d5792bb379" "6c7db7fdf356cf6bde4236248b17b129624d397a8e662cf1264e41dab87a4a9a" default)))
 '(fci-rule-color "#3f1a1a")
 '(org-fontify-whole-heading-line t)
 '(window-divider-default-right-width 1)
 '(window-divider-mode t))


;; store all emacs auto-save files in one location (~/.emacs.d/auto-save-files)
(if (file-directory-p "~/.emacs.d/auto-save-files/") nil
  (make-directory "~/.emacs.d/auto-save-files/"))
(setq backup-directory-alist
      `((".*" . ,"~/.emacs.d/auto-save-files/")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/auto-save-files/" t)))

;; Allow transparency in gui mode (adjustable)
(modify-frame-parameters nil `((alpha . 85)))
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
	 (oldalpha (if alpha-or-nil alpha-or-nil 100))
	 (newalpha (if dec (- oldalpha 2) (+ oldalpha 2))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

;; C-9 will increase opacity (== decrease transparency)
;; C-8 will decrease opacity (== increase transparency
;; C-0 will returns the state to normal
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

;; suppress menu, tool, and scroll bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; winner mode
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; drag stuff
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; flycheck package for error highlighting
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-delay 0)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; remove trailing whitespace upon save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; adapative line wrap
(define-globalized-minor-mode global-adaptive-wrap-prefix-mode adaptive-wrap-prefix-mode
  (lambda () (adaptive-wrap-prefix-mode 1)))
(global-adaptive-wrap-prefix-mode 1)

;; fix shift-arrow mapping
(define-key input-decode-map "\e[A" [S-up])
(define-key input-decode-map "\e[B" [S-down])
(define-key input-decode-map "\e[C" [S-right])
(define-key input-decode-map "\e[D" [S-left])

;; fix alt-arrow mapping
(define-key input-decode-map "\e\eOA" [M-up])
(define-key input-decode-map "\e\eOB" [M-down])
(define-key input-decode-map "\e\eOC" [M-right])
(define-key input-decode-map "\e\eOD" [M-left])

;; reformat vertical bar to make it prettier
(defun my-change-window-divider ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?│)
    (set-window-display-table (selected-window) display-table)))
(add-hook 'window-configuration-change-hook 'my-change-window-divider)

;; etags for jump-to-definition
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (eshell-command
   (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))
(defadvice find-tag (around refresh-etags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.
   If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
	ad-do-it
      (error (and (buffer-modified-p)
		  (not (ding))
		  (y-or-n-p "Buffer is modified, save it? ")
		  (save-buffer))
	     (er-refresh-etags extension)
	     ad-do-it))))
(defun er-refresh-etags (&optional extension)
  "Run etags on all peer files in current dir and reload them silently."
  (interactive)
  (shell-command (format "etags *.%s" (or extension "el")))
  (let ((tags-revert-without-query t))  ; don't query, revert silently
    (visit-tags-table default-directory nil)))
(setq tags-table-list
      '("~/emacs" "/usr/local/lib/emacs/src"))

;; AucTex options
(setq TeX-PDF-mode t)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; password caching
(setq password-cache-expiry nil)

;; autofill mode
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;(add-hook 'c-mode-hook 'turn-on-auto-fill)

;; c comment block format
(defun my-prettify-c-block-comment (orig-fun &rest args)
  (let* ((first-comment-line (looking-back "/\\*\\s-*.*"))
         (star-col-num (when first-comment-line
                         (save-excursion
                           (re-search-backward "/\\*")
                           (1+ (current-column))))))
    (apply orig-fun args)
    (when first-comment-line
      (save-excursion
        (newline)
        (dotimes (cnt star-col-num)
          (insert " "))
        (move-to-column star-col-num)
        (insert "*/"))
      (move-to-column star-col-num) ; comment this line if using bsd style
      (insert "*") ; comment this line if using bsd style
     ))
  ;; Ensure one space between the asterisk and the comment
  (when (not (looking-back " "))
    (insert " ")))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; fold code
(add-hook 'c-mode-hook 'hs-minor-mode)

;; hacky fix for emacs throuhg putty
(defmacro defkbalias (old new)
  `(define-key (current-global-map) ,new
     (lookup-key (current-global-map) ,old)))

(when (not (display-graphic-p))
  (defkbalias (kbd "<end>") (kbd "C-x p e"))
  (defkbalias (kbd "C-<right>") (kbd "C-x p c r"))
  (defkbalias (kbd "C-<left>") (kbd "C-x p c l"))
  (defkbalias (kbd "C-<up>") (kbd "C-x p c u"))
  (defkbalias (kbd "C-<down>") (kbd "C-x p c d"))
  (defkbalias (kbd "C-<end>") (kbd "C-x p c e"))
  (defkbalias (kbd "C-<home>") (kbd "C-x p c h")))

;; set home directory for windows
(if (eq system-type 'windows-nt)
    (setq default-directory "C:/Users/thidinh/")
)

;; fix python deleting weirdness
(delete-selection-mode)

;; evil mode : commands
(evil-mode)
(defun evil-save-kill-buffer()
  (interactive)
  (save-buffer)
  (kill-this-buffer)
)
(evil-ex-define-cmd "q" 'kill-this-buffer)
(evil-ex-define-cmd "quit" 'save-buffers-kill-emacs)
(evil-ex-define-cmd "wq" 'evil-save-kill-buffer)

;; smooth scrolling with arrow keys
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1
)

;; disable evil-mode in initially in term mode
(evil-set-initial-state 'term-mode 'emacs)

;; custom set faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vertical-border ((t (:inherit mode-line-inactive :background "unspecified-bg" :foreground "dim gray")))))


(if (daemonp)
 (add-hook 'after-make-frame-functions
   (lambda (frame)
     (select-frame frame)
     (if window-system
	 (progn
	   (load-theme 'yoshi t)
	   (modify-frame-parameters nil `((alpha . 85))))
       (load-theme 'ample t))))
 (if window-system
     (progn
       (load-theme 'yoshi t))
   (load-theme 'ample t))
 )

;; load different themese for terminal and buffer mode
