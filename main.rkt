#lang racket

(define book '(("alvey" 3186) ("balser" 3307) 
  ("blackmon" 3870) ("bollivar" 3677) ("cozy" 3057) ("eggert" 3064) ("evans" 3019) 
  ("harper" 3056))
)

(define (leaf lst)
  ; @param: lst is a binary tree
  ; @return: true if a tree is a leaf; else false
  
  (define (helper lst count_atom count_empty)
    ; (print lst) (newline)
    (cond
      [(> (length lst) 3) #f]
      [(= (+ count_atom count_empty) 3) #t]
      [(empty? lst) #f]
      [(= count_atom 0)
       (cond
         [(null? (car lst)) #f]
         [(not (list? (car (car lst)))) (helper (cdr lst) (+ count_atom 1) count_empty)]
         [else #f]
         )
      ]
      [(empty? (car lst)) (helper (cdr lst) count_atom (+ count_empty 1))]
      [else #f]
    )
  )
  (helper lst 0 0)
  
)


(define (left-subtree bst)
   (car (cdr bst))
)

(define (right-subtree bst)
   (car (cdr (cdr bst)))
)

(define (bst-construct lst)

  ; list is translated to vector here
  ; for constant time lookup via index
  (define v (list->vector lst))
  (define (helper l_index r_index)
    ;(printf "l: ~a" l_index) (newline)
    ;(printf "r: ~a" r_index) (newline)
    (cond
      [(empty? v) v]
      [(< r_index l_index) '()]
      [else
       (let ([mid_index (floor (/ (+ l_index r_index) 2))]) mid_index
         (append (list (vector-ref v mid_index)) (list (helper l_index (- mid_index 1))) (list (helper (+ mid_index 1) r_index)))
       )
      ]
    )
  )

  (helper 0 (- (length lst) 1))
)

; We know we went through inorder traversal in the class
; but that would take O(n) for search() in a bst, which would
; destroy the purpose of having bst and more efficient search().
; So, we are going to just implement search on a bst with O(log n).
(define (search-on-bst tree query)
  (cond
    [(empty? tree) "not in directory"]
    [(equalTo (car (car tree)) query) (car (cdr (car tree)))]
    [(lessThan query (car (car tree))) (search-on-bst (left-subtree tree) query)] ; expand left subtree
    [(greaterThan query (car (car tree))) (search-on-bst (right-subtree tree) query)] ; expand right subtree
   )
)

; find the index of the new element "query"
; to be added in the sorted "lst"
; (A slight modification of Binary Search alg)
(define (binary-add-index lst query)
  (define v (list->vector lst))

  (define (helper l r)
    (cond
      [(< r l) (+ r 1)]
      [else
       (let ([mid_index (floor (/ (+ l r) 2))]) mid_index
         (cond
           [(equalTo (car query) (car (vector-ref v mid_index))) mid_index]
           [(lessThan (car query) (car (vector-ref v mid_index))) (helper l (- mid_index 1))]
           [(greaterThan (car query) (car (vector-ref v mid_index))) (helper (+ mid_index 1) r)]
         )
       )
      ]
    )
  )
  (helper 0 (- (vector-length v) 1))
)

(define (add lst ele)
  (let ([index (binary-add-index lst ele)]) index
    (vector->list (vector-append ; append all 3 parts listed below
                   (vector-take (list->vector lst) index) ; left part
                   (vector ele) ; element to be added
                   (vector-take-right (list->vector lst) (- (length lst) index)) ; right part
     ))       
  )
)

(define (add-to-bst bst ele)
  (bst-construct (add (sort-bst bst) ele))
)

(define (sort-bst lst)
  (cond
    [(null? lst) lst]
    [else
     (append (sort-bst (left-subtree lst)) (list (car lst)) (sort-bst (right-subtree lst)))
    ]
  )
)



(define (lessThan name1 name2)
  (if (string<? name1 name2) #t
    #f
  )
)

(define (greaterThan name1 name2)
  (if (string>? name1 name2) #t
    #f
  )
)

(define (equalTo name1 name2)
  (if (string=? name1 name2) #t
    #f
  )
)


;;;;;;; Mergesort ;;;;;;;;;;

(define (merge-sorted-lsts lst1 lst2)
  ; O(n) time merging alogrithm
  (cond
    [(null? lst1) lst2]
    [(null? lst2) lst1]
    [else
     (if (lessThan (car (car lst1)) (car (car lst2)))
         (append (list (car lst1)) (merge-sorted-lsts (cdr lst1) lst2))
         (append (list (car lst2)) (merge-sorted-lsts lst1 (cdr lst2)))
      )
     ]
   )
)

(define (left-split lst index)
  (cond
    [(= index 0) (list (car lst))]
    [else
     (append (list (car lst)) (left-split (cdr lst) (- index 1)))
    ]
  )
)

(define (right-split lst index)
  (cond
    [(= index 0) (cdr lst)]
    [else
     (right-split (cdr lst) (- index 1))
    ]
  )
)

(define (mergesort lst)
  ;(print lst) (newline)
  (let ([index (floor (/ (- (length lst) 1) 2))]) index
  ;(printf "Index: ~a" index) (newline)
  (cond
    [(null? lst) lst]
    [(null? (cdr lst)) lst]
    [else
     (merge-sorted-lsts (mergesort (left-split lst index)) (mergesort (right-split lst index)))
    ]
   )
  )
)

(define (main) ; to test implementations
  (printf "current directory: ~a" book) (newline) (newline)
  (printf "calling bst-contruct() on directory:\n ~a "(bst-construct book)) (newline) (newline)
  (printf "search for \"cozy\'s\" number: ~a" (search-on-bst (bst-construct book) "cozy")) (newline) (newline)
  ;(printf "add (\"b\" 123) into the (sorted) book: ~a" (add book '("b" 123))) (newline)
  (printf "add (\"b\" 123) to a bst-book (and rebalance): ~a" (add-to-bst (bst-construct book) '("b" 123))) (newline) (newline)
  (printf "call \"sort-bst()\" on above bst and returns a sorted list: ~a" (sort-bst (add-to-bst (bst-construct book) '("b" 123))))
)

(main)
