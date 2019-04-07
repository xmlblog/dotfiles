;;; package --- Summary
;;; Commentary:
;;;
;;; define directories that will be used by other configuration settings.
;;;
;;; Code:
(defconst personal-config-dir
  (romney/ensure-directory
   (expand-file-name "config" user-emacs-directory)))

(defconst personal-data-dir
  (romney/ensure-directory
   (expand-file-name "data" user-emacs-directory)))

(defconst personal-lib-dir
  (romney/ensure-directory
   (expand-file-name "lib" user-emacs-directory) t))

(defconst personal-bookmarks-dir
  (romney/ensure-directory
   (expand-file-name "bookmarks" personal-data-dir)))

(defconst personal-org-dir
  (romney/ensure-directory
   (expand-file-name "org" personal-data-dir)))

(defconst personal-org-file-todo
  (expand-file-name "todos.org.gpg" personal-org-dir))

(defconst personal-org-file-notes
  (expand-file-name "notes.org.gpg" personal-org-dir))

(defconst personal-org-file-journal
  (expand-file-name "journal.org.gpg" personal-org-dir))

(defconst personal-org-file-cookbook
  (expand-file-name "cookbook.org" personal-org-dir))

(defconst personal-org-file-snippets
  (expand-file-name "snippets.org" personal-org-dir))

(defconst personal-org-file-work-calendar
  (expand-file-name "work-calendar.org" personal-org-dir))

(defconst personal-org-template-dir
  (expand-file-name "templates" personal-org-dir))

(defconst personal-org-template-journal
  (expand-file-name "journal.template" personal-org-template-dir))

(defconst personal-org-template-note
  (expand-file-name "note.template" personal-org-template-dir))

(defconst personal-org-template-quote
  (expand-file-name "quote.template" personal-org-template-dir))

(provide 'romney-directories)
;;; romney-directories.el ends here
