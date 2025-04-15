
; == CONTINUOUS WITH LOADER TIME ===============================================

(define (domain gripper-continuous)
    ; (:requirements :typing :strips :fluents :processes :events)

    (:types mover loader ball)

    (:predicates
        (free ?m - mover)
        (carry ?b - ball ?m - mover) 
        (moving ?m - mover) 
        (topositive ?m)
        (busyloading ?l - loader ?b - ball)
        (isloaded ?b - ball)
        (equal ?m1 - mover ?m2 - mover)
        (ischeap ?l - loader)
        (isfragile ?b - ball)
    )

    (:functions
        (at-robby ?m - mover)
        (position ?b - ball)
        (velocity)
        (loadertimer ?l - loader)
        (weight ?b - ball)
    )

    (:action start_forward
        :parameters (?m - mover)
        :precondition (and 
            (not (moving ?m)) (= (at-robby ?m) 0) (free ?m)
        )
        :effect (and 
            (moving ?m) (topositive ?m) 
        )
    )
    (:process goto_pickup
        :parameters (?m - mover)
        :precondition (and
            (moving ?m) (topositive ?m) (free ?m) 
        )
        :effect (and
            (increase (at-robby ?m) (* #t 1))
        )
    )
    (:action stop_at_ball
        :parameters (?m - mover ?b - ball)
        :precondition (and
            (moving ?m) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) 
        )
        :effect (and
            (not (moving ?m))
        )
    )
    (:action pickup
        :parameters (?m - mover ?b - ball)
        :precondition (and
            (not (moving ?m)) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
        )
        :effect (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (free ?m))
        )
    )
    (:action pickup_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball)
        :precondition (and
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (at-robby ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (at-robby ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
        )
        :effect (and
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
        )
    )
    (:process backto_loader
        :parameters (?m - mover ?b - ball)
        :precondition (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (> (at-robby ?m) 0) (<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (decrease (at-robby ?m) (* #t 1.0)) (decrease (position ?b) (* #t 1.0))
        )
    )
    (:process backto_loader_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball)
        :precondition (and
            (not (equal ?m1 ?m2))
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (> (at-robby ?m1) 0) 
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (> (at-robby ?m2) 0)
        )
        :effect (and
            (decrease (at-robby ?m1) (* #t 1.0)) (decrease (at-robby ?m2) (* #t 1.0))
            (decrease (position ?b) (* #t 1.0))
        )
    )
    (:event stop_handover
        :parameters (?m - mover ?b - ball ?l - loader)
        :precondition (and
            (or (= (at-robby ?m) 0) (= (position ?b) 0)) (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (busyloading ?l ?b)) (<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (not (moving ?m)) (topositive ?m) (not (carry ?b ?m)) (busyloading ?l ?b) (free ?m)
        )
    )
    (:event stop_handover_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball ?l - loader)
        :precondition (and
            (not (equal ?m1 ?m2))
            (= (at-robby ?m1) 0) (= (position ?b) 0) (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1)
            (= (at-robby ?m2) 0) (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (or (not (ischeap ?l)) (<= (weight ?b) 50))
            (not (busyloading ?l ?b))
        )
        :effect (and
            (not (moving ?m1)) (topositive ?m1) (not (carry ?b ?m1)) (free ?m1) 
            (not (moving ?m2)) (topositive ?m2) (not (carry ?b ?m2)) (free ?m2)
            (busyloading ?l ?b)
        )
    )
    (:process load
        :parameters (?l - loader ?b - ball)
        :precondition (and 
            (busyloading ?l ?b) 
            (or (and (< (loadertimer ?l) 4) (not (isfragile ?b))) (and (< (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (increase (loadertimer ?l) (* #t 1))
    )
    (:event doneload
        :parameters (?b - ball ?l - loader)
        :precondition (and 
            (busyloading ?l ?b)
            (or (and (= (loadertimer ?l) 4) (not (isfragile ?b))) (and (= (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (and (assign (loadertimer ?l) 0) (not (busyloading ?l ?b)) (isloaded ?b))
    )
       
)

