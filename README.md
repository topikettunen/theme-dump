# theme-dump

Simple tool for aspiring Emacs theme developers for dumping all the current
theme's faces to file which can then work as a good starting point for a new
theme.

## Sample output

Run with `M-x theme-dump-current-faces` and give output filename.

```emacs-lisp
(deftheme new-theme)

(let ((class '(class color) (min-colors 89)))
  (custom-theme-set-faces
   'new-theme
   ...
   ))

(provide-theme 'new-theme)
```
