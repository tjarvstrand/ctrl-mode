;;; ctrl-mode.el --- More ergonomic navigation

;; Copyright 2013 Thomas Järvstrand <tjarvstrand@gmail.com>

;; Author: Thomas Järvstrand <thomas.jarvstrand@gmail.com>
;; Keywords: emacs
;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;

(defvar ctrl-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<return>") 'ctrl-mode-toggle)
    map)
  "Keymap for EDTS.")

(global-set-key (kbd "<return>") 'ctrl-mode-toggle)

(defun ctrl-mode-toggle ()
  (interactive)
  (if (minibufferp (current-buffer))
      (minibuffer-complete-and-exit)
    (call-interactively 'ctrl-mode)))


(define-minor-mode ctrl-mode
  "Add a control modifier to all character insertions. For convenient navigation."
  :lighter " CTRL"
  :keymap ctrl-mode-map
  :global t
  (if ctrl-mode
      (ad-activate-regexp "ctrl-.*")
    (ad-deactivate-regexp "ctrl-.*")))

(defadvice self-insert-command (around ctrl-self-insert-command)
  (if (or (event-modifiers last-command-event) (minibufferp (current-buffer)))
      ad-do-it
    (let ((evt (event-convert-list `(control ,last-command-event))))
      (add-to-list 'unread-command-events evt))))


