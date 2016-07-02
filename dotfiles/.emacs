
;; Setup load-path, autoloads and your lisp system
;; Not needed if you install SLIME via MELPA

(add-to-list 'load-path "/home/${user)/descarcari/github/slime")
(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/clisp")




(put 'upcase-region 'disabled nil)
