;; Emacs Configuration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq package-list '(bind-key
		     helm
		     magit
		     pretty-mode
		     paredit
		     slime
		     exec-path-from-shell
		     yasnippet))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defaults
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))
(if (fboundp 'show-paren-mode) (show-paren-mode 1))
(if (fboundp 'transient-mark-mode) (transient-mark-mode 1))
(if (fboundp 'column-number-mode) (column-number-mode 1))

(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Enable some commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'default-frame-alist '(font . "Inconsolata for Powerline-18"))
(set-face-attribute 'default t :font "Inconsolata for Powerline-18")
;(load-theme "twilight-bright")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'bind-key)

;; Fix mac keyboard
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier nil)
(setq mac-command-modifier nil)

(bind-key "M-/" 'hippie-expand)

(bind-key "C-s" 'isearch-forward-regexp)
(bind-key "C-r" 'isearch-backward-regexp)
(bind-key "C-M-s" 'isearch-forward)
(bind-key "C-M-r" 'isearch-backward)

;; Joins Lines into one
(bind-key  "M-j" '(lambda () (interactive) (join-line -1)))

;; Kill line from the left
(bind-key "<s-backspace>" '(lambda () (interactive) (kill-line 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Fix MacOS not loading PATH from user shell
;; but from a predefined variable
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;;
;;; HELM
;;;
(helm-mode 1)

;;;
;;; EWW
;;; 
(setq browse-url-browser-function 'eww-browse-url)

;;;
;;; ORG
;;;
(setq org-log-done 'time)

;;;
;;; YASNIPPET
;;;
(require 'yasnippet)
(yas-global-mode 1)

;;;
;;; MAGIT
;;;
(require 'magit)
;(setq magit-git-executable "/usr/local/bin/git")
(bind-key "C-c g" 'magit-status)
(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

;; Restore windows after exiting magit
(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

;;;
;;; PRETTY
;;;
(require 'pretty-mode)
(global-pretty-mode 1)

;;;
;;; SLIME
;;;
(setq inferior-lisp-program "sbcl --noinform")
(require 'slime-autoloads)
(slime-setup '(slime-fancy slime-asdf slime-banner slime-indentation))
(setq lisp-indent-function 'common-lisp-indent-function)
(define-key slime-mode-map (kbd "C-c s") 'slime-scratch)

(mapc (lambda (mode)
        (add-hook mode 'paredit-mode))
      '(lisp-mode-hook
        lisp-interaction-mode-hook
        slime-mode-hook
        emacs-lisp-mode-hook))

;; quicklisp repl command
(defun slime-quickload (system &rest keyword-args)
  "Quickload System."
  (slime-save-some-lisp-buffers)
  (slime-display-output-buffer)
  (message "Performing Quicklisp load of system %S" system)
  (slime-repl-shortcut-eval-async
   `(ql:quickload ,system)
   (slime-asdf-operation-finished-function system)))


(defun slime-find-all-system-names ()
  (flet ((first-char (string &optional (string-start 0))
	   (substring string string-start (1+ string-start))))
    (cl-union
     (mapcar
      (lambda (b)
	(let ((string-start 0)
	      (package-name (with-current-buffer b (slime-current-package))))
	  (when (equal "#" (first-char package-name string-start))
	    (incf string-start))
	  (when (equal ":" (first-char package-name string-start))
	    (incf string-start))
	  (downcase (substring package-name string-start))))
      (cl-remove-if-not
       (lambda (b) (equal (buffer-local-value 'major-mode b)
		     'lisp-mode))
       (buffer-list)))
     (slime-eval '(cl:nunion
		   (swank:list-asdf-systems)
		   (cl:mapcar 'ql-dist:name
		    (ql:system-list))
		   :test 'cl:string=))
     :test 'string-equal)))

;; Quickload a system
(defslime-repl-shortcut slime-repl-quickload
    ("quickload" "+ql" "ql")
  (:handler (lambda ()
	      (interactive)
	      (let* ((system-names
		       (slime-find-all-system-names))
		     (default-value (slime-find-asd-file
				     (or default-directory
					 (buffer-file-name))
				     system-names))
		     (prompt (concat "System "
				     (if default-value
					 (format " (default `%s'): " default-value)
					 ": ")))
		     (system (completing-read prompt
					      (slime-bogus-completion-alist system-names)
					      nil nil nil
					      'slime-system-history
					      default-value)))
		(insert "(ql:quickload :" system ")")
		(slime-repl-send-input t))))
  (:one-liner "Quickload a system"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(ansi-term-color-vector
   [unspecified "#FFFFFF" "#d15120" "#5f9411" "#d2ad00" "#6b82a7" "#a66bab" "#6b82a7" "#505050"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("40bc0ac47a9bd5b8db7304f8ef628d71e2798135935eb450483db0dbbfff8b11" "603a9c7f3ca3253cb68584cb26c408afcf4e674d7db86badcfe649dd3c538656" "c1390663960169cd92f58aad44ba3253227d8f715c026438303c09b9fb66cdfb" "4d80487632a0a5a72737a7fc690f1f30266668211b17ba836602a8da890c2118" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(fci-rule-character-color "#d9d9d9")
 '(fci-rule-color "#eee8d5")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100))))
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(magit-use-overlays nil)
 '(package-selected-packages
   (quote
    (tao-theme powerline sr-speedbar go-mode rust-mode common-lisp-snippets yasnippet twilight-bright-theme greymatters-theme sublime-themes solarized-dark solarized-theme slime pretty-mode paredit magit helm exec-path-from-shell color-theme bind-key)))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c85d17")
     (60 . "#be730b")
     (80 . "#b58900")
     (100 . "#a58e00")
     (120 . "#9d9100")
     (140 . "#959300")
     (160 . "#8d9600")
     (180 . "#859900")
     (200 . "#669b32")
     (220 . "#579d4c")
     (240 . "#489e65")
     (260 . "#399f7e")
     (280 . "#2aa198")
     (300 . "#2898af")
     (320 . "#2793ba")
     (340 . "#268fc6")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#fdf6e3" "#eee8d5" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#657b83" "#839496"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
