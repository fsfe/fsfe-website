<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY dbstyle PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA DSSSL>
]>

<style-sheet>
<style-specification use="docbook">
<style-specification-body>


(define tex-backend 
  ;; Are we using the TeX backend?
  #t)

(define %paper-type%
  ;; Name of paper type
  "A4")

(define %default-quadding% 
  ;; The default quadding
  'justify)

(define %two-side% 
  ;; Is two-sided output being produced?
  #f)

(define %hyphenation%
  ;; Allow automatic hyphenation?
  #t)
    

(define %graphic-default-extension% 
  ;; Default extension for graphic FILEREFs
  "eps")
    
(define %generate-book-titlepage%
  ;; Should a book title page be produced?
  #t)

(define ($object-titles-after$)
  ;; List of objects who's titles go after the object
  (list (normalize "figure")))


</style-specification-body>
</style-specification>

<external-specification id="docbook" document="dbstyle">

</style-sheet>

