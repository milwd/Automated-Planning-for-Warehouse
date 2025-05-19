
; == CONTINUOUS WITH LOADER TIME ===============================================

(define (domain gripper-continuous)
    ; (:requirements :typing :strips :fluents :processes :events)

    (:types 
        mover loader crate
        group
    )

    (:predicates
        (free ?m - mover)
        (carry ?b - crate ?m - mover) 
        (moving ?m - mover) 
        (topositive ?m)
        (busyloading ?l - loader ?b - crate)
        (isloaded ?b - crate)
        (equal ?m1 - mover ?m2 - mover)
        (ischeap ?l - loader)
        (isfragile ?b - crate)
        (belong ?b - crate ?g - group)
    )

    (:functions
        (rob_position ?m - mover)
        (position ?b - crate)
        (velocity)
        (loadertimer ?l - loader)
        (weight ?b - crate)
    )

    (:action start_forward
        :parameters (?m - mover)
        :precondition (and 
            (not (moving ?m)) (= (rob_position ?m) 0) (free ?m)
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
            (increase (rob_position ?m) (* #t 1))
        )
    )
    (:action stop_at_crate
        :parameters (?m - mover ?b - crate)
        :precondition (and
            (moving ?m) (topositive ?m) (= (rob_position ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) 
        )
        :effect (and
            (not (moving ?m))
        )
    )
    (:action pickup
        :parameters (?m - mover ?b ?b2 - crate ?g - group)
        :precondition (and
            (not (moving ?m))
            (topositive ?m)
            (= (rob_position ?m)
            (position ?b))
            (not (isloaded ?b))
            (> (position ?b) 0)
            (<= (weight ?b) 50)
            (not (isfragile ?b))
            (free ?m)
            ; supercool logic below
            (or 
                (and 
                    (not (isloaded ?b))
                    (belong ?b ?g)
                    (isloaded ?b2)
                    (belong ?b2 ?g)
                )
                (not (isloaded ?b))
            )
        )
        :effect (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (free ?m))
        )
    )
    (:action pickup_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - crate)
        :precondition (and
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (rob_position ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (rob_position ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
        )
        :effect (and
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
        )
    )
    (:process backto_loader
        :parameters (?m - mover ?b - crate)
        :precondition (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (> (rob_position ?m) 0) (<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (decrease (rob_position ?m) (* #t 1.0)) (decrease (position ?b) (* #t 1.0))
        )
    )
    (:process backto_loader_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - crate)
        :precondition (and
            (not (equal ?m1 ?m2))
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (> (rob_position ?m1) 0) 
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (> (rob_position ?m2) 0)
        )
        :effect (and
            (decrease (rob_position ?m1) (* #t 1.0)) (decrease (rob_position ?m2) (* #t 1.0))
            (decrease (position ?b) (* #t 1.0))
        )
    )
    (:event stop_handover
        :parameters (?m - mover ?b - crate ?l - loader)
        :precondition (and
            (or (= (rob_position ?m) 0) (= (position ?b) 0)) (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (busyloading ?l ?b)) (<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (not (moving ?m)) (topositive ?m) (not (carry ?b ?m)) (busyloading ?l ?b) (free ?m)
        )
    )
    (:event stop_handover_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - crate ?l - loader)
        :precondition (and
            (not (equal ?m1 ?m2))
            (= (rob_position ?m1) 0) (= (position ?b) 0) (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1)
            (= (rob_position ?m2) 0) (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (or (not (ischeap ?l)) (<= (weight ?b) 50))
            (not (busyloading ?l ?b))
        )
        :effect (and
            (not (moving ?m1)) (topositive ?m1) (not (carry ?b ?m1)) (free ?m1) 
            (not (moving ?m2)) (topositive ?m2) (not (carry ?b ?m2)) (free ?m2)
            (busyloading ?l ?b)
        )
    )
    (:process load
        :parameters (?l - loader ?b - crate)
        :precondition (and 
            (busyloading ?l ?b) 
            (or (and (< (loadertimer ?l) 4) (not (isfragile ?b))) (and (< (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (increase (loadertimer ?l) (* #t 1))
    )
    (:event doneload
        :parameters (?b - crate ?l - loader)
        :precondition (and 
            (busyloading ?l ?b)
            (or (and (= (loadertimer ?l) 4) (not (isfragile ?b))) (and (= (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (and (assign (loadertimer ?l) 0) (not (busyloading ?l ?b)) (isloaded ?b))
    )
       
)

