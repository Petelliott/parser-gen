;;;; some useful leaf combinators
(defpackage :misc
  (:use :cl)
  (:export
    #:test
    #:str-lit
    #:strseq
    #:int-literal
    #:identifier
    #:wspace
    #:sym
    #:alphanum
    #:digit
    #:alpha))

(in-package :misc)


(comb:defcomb strseq (str)
  "parses a string that matches str"
  (util:strparser
    (comb:seql
      (mapcar
        (lambda (ch) (comb:lit ch))
        (coerce str 'list)))))


(comb:defcomb int-literal ()
  "parses an integer literal"
  (comb:capply
    #'parse-integer
    (util:strparser
      (util:rep+
        (digit)))))


;;TODO: support common lisp or c style identifiers only
(comb:defcomb identifier ()
  "parses an alphanumeric identifier"
  (util:strparser
    (util:rep+
      (alphanum))))


(comb:defcomb wspace ()
  "parses any whitespace, including none"
  (util:rep*
    (comb:any
      (comb:lit #\ )
      (comb:lit #\return)
      (comb:lit #\linefeed)
      (comb:lit #\tab))))


(comb:defcomb sym ()
  "matches any ascii symbol"
  (comb:any
   (comb:lit #\!)
   (comb:lit #\")
   (comb:lit #\#)
   (comb:lit #\$)
   (comb:lit #\%)
   (comb:lit #\&)
   (comb:lit #\')
   (comb:lit #\()
   (comb:lit #\))
   (comb:lit #\*)
   (comb:lit #\+)
   (comb:lit #\,)
   (comb:lit #\-)
   (comb:lit #\.)
   (comb:lit #\/)
   (comb:lit #\:)
   (comb:lit #\;)
   (comb:lit #\<)
   (comb:lit #\=)
   (comb:lit #\>)
   (comb:lit #\?)
   (comb:lit #\@)
   (comb:lit #\[)
   (comb:lit #\\)
   (comb:lit #\])
   (comb:lit #\^)
   (comb:lit #\_)
   (comb:lit #\`)
   (comb:lit #\{)
   (comb:lit #\|)
   (comb:lit #\})
   (comb:lit #\~)))


(comb:defcomb alphanum ()
  "matches any latin character or digit"
  (comb:any (alpha) (digit)))


(comb:defcomb digit ()
  "matches any ascii character"
  (comb:any
    (comb:lit #\0)
    (comb:lit #\1)
    (comb:lit #\2)
    (comb:lit #\3)
    (comb:lit #\4)
    (comb:lit #\5)
    (comb:lit #\6)
    (comb:lit #\7)
    (comb:lit #\8)
    (comb:lit #\9)))


(comb:defcomb alpha ()
  "matches any ascii latin character, upper or lower case"
  (comb:any
    (comb:lit #\a)
    (comb:lit #\b)
    (comb:lit #\c)
    (comb:lit #\d)
    (comb:lit #\e)
    (comb:lit #\f)
    (comb:lit #\g)
    (comb:lit #\h)
    (comb:lit #\i)
    (comb:lit #\j)
    (comb:lit #\k)
    (comb:lit #\l)
    (comb:lit #\m)
    (comb:lit #\n)
    (comb:lit #\o)
    (comb:lit #\p)
    (comb:lit #\q)
    (comb:lit #\r)
    (comb:lit #\s)
    (comb:lit #\t)
    (comb:lit #\u)
    (comb:lit #\v)
    (comb:lit #\w)
    (comb:lit #\x)
    (comb:lit #\y)
    (comb:lit #\z)
    (comb:lit #\A)
    (comb:lit #\B)
    (comb:lit #\C)
    (comb:lit #\D)
    (comb:lit #\E)
    (comb:lit #\F)
    (comb:lit #\G)
    (comb:lit #\H)
    (comb:lit #\I)
    (comb:lit #\J)
    (comb:lit #\K)
    (comb:lit #\L)
    (comb:lit #\M)
    (comb:lit #\N)
    (comb:lit #\O)
    (comb:lit #\P)
    (comb:lit #\Q)
    (comb:lit #\R)
    (comb:lit #\S)
    (comb:lit #\T)
    (comb:lit #\U)
    (comb:lit #\V)
    (comb:lit #\W)
    (comb:lit #\X)
    (comb:lit #\Y)
    (comb:lit #\Z)))
