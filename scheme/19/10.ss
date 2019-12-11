(load "~/code/advent/load.ss")
(advent-year 19)
(advent-day 10)

(define points
  (let ((grid (map string->list (parse-advent lines-raw))))
    (filter-map identity
                (apply append
                       (map (lambda (i row)
                              (map (lambda (j x)
                                     (and (eqv? x #\#)
                                          (+ j (* 0+i i))))
                                   (enumerate row)
                                   row))
                            (enumerate grid)
                            grid)))))

;; to make 0 clockwise pointing up, which is actually down because the
;; coordinates are wonky.
(define (phi z)
  (let ((a (angle (* 0+i z))))
    (if (< a 0) a (- a 2pi))))

(define (split-ray alpha zs)
  (drop-while (lambda (z) (equal? (angle z) alpha)) zs))

(define (translating points center)
  (rank-on (lambda (z) (phi (- z center))) (remv center points)))

(define (partA)
  (define (visible x)
    (length (group-with eqv? (sort <
                                   (map (lambda (z)
                                          (phi (- z x)))
                                        (remv x points))))))
  (maximum-on points visible))

(define monitoring-station
  (cdr (partA)))

;; problem asks for 200th of 303, so this just drops hidden points
(define (partB)
  (list-ref (group-with (lambda (u v)
                          (eqv? (car u) (car v)))
                        (translating points monitoring-station))
            199))