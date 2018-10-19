;; setup package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; load deeper-blue for gui and manjo-dark for terminal
(if (display-graphic-p)
    (load-theme 'deeper-blue)
  (load-theme 'manoj-dark))

(setq inhibit-startup-screent t) ; hide startup screen
(setq inhibit-splash-screen t) ; hide welcome screen
(when window-system (set-frame-size (selected-frame) 140 40)) ; initial frame size

;; create shortcuts function

(defun fav-commands () (interactive)
       (split-window-right -40)
       (other-window 1)
       (find-file "~/.emacs.d/fav-commands.txt")
)

(when (fboundp 'electric-indent-mode) (electric-indent-mode -1)) ; turn off automatic indents
(global-linum-mode t) ; add line numbers

(windmove-default-keybindings) ; allow directional window navigation

; if on linux, set default directory
(if (eq system-type 'gnu/linux)
    (setq default-directory "~/Documents/School/"))

; if on windows, set default directory
(if (eq system-type 'windows-nt)
    (setq default-directory "C:\\Users\\thidinh\\My_Documents\\School"))
