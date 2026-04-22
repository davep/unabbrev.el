;;; unabbrev.el --- Tools to expand abbrevs -*- lexical-binding: t -*-
;; Copyright 2026 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 0.01
;; Keywords: abbrev, convenience
;; URL: https://github.com/davep/unabbrev.el
;; Package-Requires: ((emacs "26.1"))

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; unabbrev.el provides simple tools for expanding abbrevs.

;;; Code:

(eval-when-compile
  (require 'cl-lib))

(defun unabbrev-picker ()
  "Pick an abbrev to expand at `point'."
  (interactive)
  (if-let* ((abbreviations
             (sort
              (cl-loop
               for table in (list local-abbrev-table global-abbrev-table)
               nconc (cl-loop
                      for abbrev being the symbols of table
                      for shortcut = (symbol-name abbrev)
                      for expansion = (abbrev-expansion shortcut table)
                      when expansion collect (cons (format "%-10s %s" shortcut expansion) shortcut)))))
            (abbreviation (completing-read "Abbreviation: " abbreviations nil t))
            (shortcut (cdr (assoc abbreviation abbreviations))))
      (save-excursion
        (insert shortcut)
        (expand-abbrev))
    (user-error "No abbreviations found")))

(provide 'unabbrev)

;;; unabbrev.el ends here
