;;; theme-dump.el --- Simple tool written for aspiring theme developers -*- lexical-binding: t; -*-

;; Author: Topi Kettunen <topi@topikettunen.com>
;; URL: https://github.com/topikettunen/tok-theme
;; Version: 0.1
;; Package-Requires: ((emacs "26.1") (f "1.0"))

;; This is free and unencumbered software released into the public domain.
;; 
;; Anyone is free to copy, modify, publish, use, compile, sell, or
;; distribute this software, either in source code form or as a compiled
;; binary, for any purpose, commercial or non-commercial, and by any
;; means.
;; 
;; In jurisdictions that recognize copyright laws, the author or authors
;; of this software dedicate any and all copyright interest in the
;; software to the public domain. We make this dedication for the benefit
;; of the public at large and to the detriment of our heirs and
;; successors. We intend this dedication to be an overt act of
;; relinquishment in perpetuity of all present and future rights to this
;; software under copyright law.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.
;; 
;; For more information, please refer to <https://unlicense.org>

;; This file is not part of Emacs.

;;; Commentary:

;; Simple tool written for aspiring theme developers.

;;; Code:

(require 'cl-lib)
(require 'f)

(defconst theme-dump--default-format-string "%s %s ")
(defconst theme-dump--string-format-string "%s \"%s\" ")
(defconst theme-dump--custom-theme-format-string
  "(deftheme new-theme)

(let ((class '(class color) (min-colors 89)))
  (custom-theme-set-faces
   'new-theme
%s))

(provide-theme 'new-theme)")

(defun theme-dump-current-faces (dump-path)
  (interactive (list (read-string "Dump faces to: " "/tmp/")))
  (let ((faces ""))
    (dolist (f (face-list))
      (let ((attr-str ""))
        (dolist (a (face-all-attributes f))
          (setq attr-str
                (concat attr-str (theme-dump--format-attr-str f a))))
        (if (not (equal attr-str ""))
            (setq faces
                  (concat faces
                          (format "   `(%s ((,class (%s))))\n"
                                  f
                                  (string-trim-right attr-str))))
          (setq faces (concat faces (format "   `(%s ((t (nil))))\n" f))))))
    (f-write-text (format theme-dump--custom-theme-format-string
                          ;; remove trailing newline
                          (substring faces 0 -1))
                  'utf-8
                  dump-path)
    (find-file dump-path)))

(defun theme-dump--format-attr-str (face attr)
  (unless (equal (face-attribute face (car attr))
                 'unspecified)
    (cl-typecase (face-attribute face (car attr))
      (integer (format theme-dump--default-format-string
                       (symbol-name (car attr))
                       (face-attribute face (car attr))))
      (float (format theme-dump--default-format-string
                     (symbol-name (car attr))
                     (face-attribute face (car attr))))
      (string (format theme-dump--string-format-string
                      (symbol-name (car attr))
                      (face-attribute face (car attr))))
      (symbol (format theme-dump--default-format-string
                      (symbol-name (car attr))
                      (face-attribute face (car attr)))))))

(provide 'theme-dump)

;;; theme-dump.el ends here
