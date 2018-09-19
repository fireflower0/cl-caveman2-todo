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

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
