<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY dbstyle PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA dsssl>
]>

<style-sheet>
<style-specification use="docbook">
<style-specification-body>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define %root-filename%
  ;; Name for the root HTML document
  "index")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Presentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define %graphic-default-extension% 
  ;; Default extension for graphic FILEREFs
  "png")

(define ($object-titles-after$)
  ;; List of objects who's titles go after the object
  (list (normalize "figure")))

; For a good output use either 
; both %generate-article-toc% and %generate-article-titlepage% to #f or 
; both to #t
(define %generate-article-toc% 
  ;; Should a Table of Contents be produced for Articles?
  #f)

(define %generate-article-titlepage% 
  ;; Should an article title page be produced?
  #f)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HTML specific
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define %html-ext% 
  ;; Default extension for HTML output files
  ".html")

(define %html40%
  ;; Generate HTML 4.0
  #t)

(define %html-pubid%
  ;; What public ID are you declaring your HTML compliant with?
  "-//W3C//DTD XHTML 1.0 Transitional//EN")

(define %stylesheet%
  ;; Name of the stylesheet to use
  "lightNLegible.css")

(define %css-decoration%
  ;; Enable CSS decoration of elements
  #t)

(define %fix-para-wrappers%
  ;; Block element in para hack
  #t)


</style-specification-body>
</style-specification>

<external-specification id="docbook" document="dbstyle">

</style-sheet>

