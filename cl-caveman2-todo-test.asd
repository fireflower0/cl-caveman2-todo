(defsystem "cl-caveman2-todo-test"
  :defsystem-depends-on ("prove-asdf")
  :author "fireflower0"
  :license ""
  :depends-on ("cl-caveman2-todo"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-caveman2-todo"))))
  :description "Test system for cl-caveman2-todo"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
