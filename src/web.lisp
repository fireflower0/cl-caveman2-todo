(in-package :cl-user)
(defpackage cl-caveman2-todo.web
  (:use :cl
        :caveman2
        :cl-caveman2-todo.config
        :cl-caveman2-todo.view
        :cl-caveman2-todo.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :cl-caveman2-todo.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute ("/task-add" :method :POST) (&key |name|)
  (render-todo-list (insert-task |name|)))

(defroute ("/task-update" :method :POST) (&key |id| |name|)
  (render-todo-list (update-task |id| |name|)))

(defroute ("/task-delete" :method :POST) (&key |id|)
  (render-todo-list (delete-task |id|)))

;;
;; Functions

(defun create-table ()
  (with-connection (db)
    (execute
     (create-table (:tasks :if-not-exists t)
         ((id   :type 'integer :primary-key t :unique t :autoincrement t)
          (name :type 'text))))))

(defun view-tasks ()
  (with-connection (db)
    (let ((result (retrieve-all (select (:*) (from :tasks)))))
      (dolist (n result)
        (format t "~{~A ~}~%" n)))))

(defun insert-task (data)
  (with-connection (db)
    (execute
     (insert-into :tasks
                  (set= :name data)))))

(defun update-task (id name)
  (with-connection (db)
    (execute
     (update :tasks
       (set= :name name)
       (where (:= :id id))))))

(defun delete-task (id)
  (with-connection (db)
    (execute
     (delete-from :tasks
       (where (:= :id id))))))

(defun render-todo-list (tasks)
  (render #P"index.html" `(:tasks ,(get-tasks tasks))))

(defun get-tasks (tasks)
  (with-connection (db)
    (retrieve-all
     (select :* (from :tasks)))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
