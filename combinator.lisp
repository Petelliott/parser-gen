(defpackage :comb
  (:use :cl)
  (:export
    #:any
    #:anyl
    #:seq
    #:seql
    #:lit
    #:lit-
    #:capply
    #:cignore
    #:defcomb
    #:c-all
    #:cnull))

(in-package :comb)


(defun any (&rest combs)
  (anyl combs))


(defun anyl (combs)
  (lambda (next save revert)
    (any-int combs next save revert)))


(defun any-int (combs next save revert)
  (if combs
    (multiple-value-bind (res stat ign)
        (funcall (car combs) next save revert)
      (if stat
        (values res t ign)
        (any-int (cdr combs) next save revert)))
    (values nil nil)))


(defun seq (&rest combs)
  (seql combs))


(defun seql (combs)
  (lambda (next save revert)
    (let ((backup (funcall save)))
      (multiple-value-bind (res stat)
          (seq-int combs next save revert)
        (if stat
          (values res stat)
          (progn
            (funcall revert backup)
            (values res stat)))))))


(defun seq-int (combs next save revert)
  (if combs
    (multiple-value-bind (res stat ign)
        (funcall (car combs) next save revert)
      (if stat
        (multiple-value-bind (resn statn ignn)
            (seq-int (cdr combs) next save revert)
          (if ign
            (values resn statn)
            (values (cons res resn) statn)))
        (values nil nil)))
    (values nil t)))


(defun lit (ch)
  (lambda (next save revert)
    (let ((backup (funcall save)))
      (if (equal ch (funcall next))
        (values ch t)
        (progn
          (funcall revert backup)
          (values nil nil))))))

(defun lit- (ch)
  (lambda (next save revert)
    (let ((backup (funcall save)) (realchar (funcall next)))
      (if (equal ch realchar)
        (progn
          (funcall revert backup)
          (values ch nil))
        (values realchar t)))))


(defun c-all ()
  (lambda (next save revert)
    (let ((n (funcall next)))
      (if n
        (values n t)
        (values n nil)))))


(defun cnull ()
  (cignore
    (lambda (next save revert)
      (values nil t))))


(defun capply (fun combinator)
  (lambda (next save revert)
    (multiple-value-bind (res stat ign)
        (funcall combinator next save revert)
      (if stat
        (values (funcall fun res) t ign)
        (values res nil ign)))))


(defun cignore (comb)
  (lambda (next save revert)
    (multiple-value-bind (res stat)
        (funcall comb next save revert)
      (values nil stat t))))


;; TODO: docstring
(defmacro defcomb (name args body)
  "quickly define a recursive combinator"
  (let ((next (gensym)) (save (gensym)) (revert (gensym)))
    `(defun ,name ,args
       (lambda (,next ,save ,revert)
         (funcall ,body ,next ,save ,revert)))))
