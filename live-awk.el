;;; live-awk.el --- Build awk commands interactively with live result sets.

;; Copyright (C) 2013 Dan LaManna

;; Author: Dan LaManna <dan.lamanna@gmail.com>
;; Version: 1.0
;; Keywords: awk

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Example Usage:
;; (add-hook 'awk-mode-hook (lambda()
;;                              (require 'live-awk)
;;                              (live-awk-mode 1)))

;;; Code:

(defgroup live-awk nil
  "Build awk commands interactively."
  :prefix "live-awk-"
  :group 'tools)

(defcustom live-awk-head-command (executable-find "head")
  "Command to run head to limit input."
  :group 'live-awk
  :type  'string)

(defcustom live-awk-awk-command (executable-find "awk")
  "Command to run awk."
  :group 'live-awk
  :type  'string)

(defcustom live-awk-max-lines 20
  "Maximum number of lines to use from the input file."
  :group 'live-awk
  :type  'integer)

(defcustom live-awk-results-buffer-name "*live-awk-results*"
  "Name of the buffer to preview live awk results in."
  :group 'live-awk
  :type  'string)

(define-minor-mode live-awk-mode
  "Build awk commands interactively with live result sets."
  nil
  " LiveAwk"
  nil
  (add-hook 'after-change-functions 'live-awk-after-change nil t)
  (setq live-awk-input-file (read-file-name "LiveAwk Input File: ")))


(defun live-awk-after-change(&rest args)
  (when (string-equal "awk-mode" (identity major-mode))
    (let ((before-awk  (format "%s -n%d %s | %s '" live-awk-head-command live-awk-max-lines live-awk-input-file live-awk-awk-command))
          (after-awk   (format "' 2> /dev/null"))
          (awk-cmd-text (buffer-substring-no-properties (point-min) (point-max))))
      (with-temp-buffer
        (insert before-awk awk-cmd-text after-awk)
        (setq updated-awk (shell-command-to-string (buffer-substring-no-properties (point-min) (point-max)))))
      (unless (string-equal updated-awk "")
        (if (not (get-buffer live-awk-results-buffer-name))
            (progn
              (let ((prev-window (selected-window)))
                (select-window (split-window-below))
                (switch-to-buffer (get-buffer-create live-awk-results-buffer-name))
                (select-window prev-window))))
        (with-current-buffer (get-buffer live-awk-results-buffer-name)
          (erase-buffer)
          (insert updated-awk))))))

(provide 'live-awk)

;;; live-awk.el ends here
