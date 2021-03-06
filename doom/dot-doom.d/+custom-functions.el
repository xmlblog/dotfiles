;;; ../src/dotfiles/doom/dot-doom.d/+functions.el -*- lexical-binding: t; -*-

;; =============================================================
;; FILE HANDLING
;; =============================================================

(defun custom/ensure-directory (path)
  "Ensures the directory path exists, creating any parents as
needed. Returns the expanded pathname."
  (let ((abspath (expand-file-name path)))
    (if (file-exists-p abspath)
        abspath
      (progn
        (make-directory abspath 'parents)
        abspath))))

(defun custom/ensure-file (path)
  "Ensures the file path exists, creating any parents as needed.
Returns the expanded pathname."
  (let ((abspath (expand-file-name path)))
    (if (file-exists-p abspath)
        abspath
      (progn
        (make-empty-file abspath 'parents)
        abspath))))

(defun custom/read-file-as-string (path)
  "Reads the given file as a string."
  (string-trim
   (with-temp-buffer
     (insert-file-contents (expand-file-name path))
     (buffer-string))))

(defun custom/port-open-p (port)
  "Returns t if the given port is in use, nil otherwise."
  (= 0 (call-process "lsof" nil nil nil "-P" "-i"
                     (concat "TCP:" (number-to-string port)))))

(defun custom/read-auth-field (field &rest params)
  (require 'auth-source)
  (let ((match (car (apply #'auth-source-search params))))
    (if match
        (let ((secret (plist-get match field)))
          (if (functionp secret)
              (funcall secret)
            secret))
      (error "%s not found for %S" field params))))

(defun custom/read-auth-username (&rest params)
  (apply #'custom/read-auth-field :user params))

(defun custom/read-auth-password (&rest params)
  (apply #'custom/read-auth-field :secret params))

;; =============================================================
;; MARKUP FUNCTIONS
;; =============================================================

(defun custom/org-markup-word (theChar)
  (save-excursion
    (backward-word)
    (insert-char theChar)
    (forward-word)
    (insert-char theChar)))

(defun custom/org-italicize-word ()
  (interactive)
  (custom/org-markup-word #x00002F))

(defun custom/org-bold-word ()
  (interactive)
  (custom/org-markup-word #x00002A))

(defun custom/org-code-word ()
  (interactive)
  (custom/org-markup-word #x00007E))

(defun custom/org-underline-word ()
  (interactive)
  (custom/org-markup-word #x00005F))

(defun custom/org-verbatim-word ()
  (interactive)
  (custom/org-markup-word #x00003D))

(defun custom/org-strike-word ()
  (interactive)
  (custom/org-markup-word #x00002B))

;; =============================================================
;; INTERACTIVE BUFFER MANIPULATION
;; =============================================================

(defun custom/just-one-space ()
  "Command to delete all but one whitespace character."
  (interactive)
  (just-one-space -1))

(defun custom/delete-horizontal-space ()
  "Command to delete all whitespace."
  (interactive)
  (just-one-space -1)
  (sp-backward-delete-char))

(defun custom/flash-view-centered ()
  "Centers vertically and flashes the current line."
  (interactive)
  (recenter)
  (+nav-flash/blink-cursor))
