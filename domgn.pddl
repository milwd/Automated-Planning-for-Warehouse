
; == CONTINUOUS WITH LOADER TIME ===============================================

(define (domain gripper-continuous)
    ; (:requirements :typing :strips :fluents :processes :events)

    (:types mover loader ball group)

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
        (currentgroupset)
    )

    (:functions
        (velocity ?m - mover)
        (max_vel ?m - mover)
        (at-robby ?m - mover)
        (position ?b - ball)
        (loadertimer ?l - loader)
        (weight ?b - ball)
        (belong ?b - ball)
        (currentgroup)
        (numofgroup ?g - group)
        (elementspergroup ?g - group)
        (battery ?m - mover)
        (maxchargebattery)
    )

    (:process drain_battery
        :parameters (?m - mover)
        :precondition (and
            (moving ?m) (> (battery ?m) 0)(>(at-robby ?m)1)
        )
        :effect (decrease (battery ?m) (* #t 1)
        )
    )
    (:event charging_battery
        :parameters (?m - mover)
        :precondition (and
            (not(moving ?m))(=(at-robby ?m)0) (< (battery ?m)  (maxchargebattery))(free ?m)
        )
        :effect (and
            (assign (battery ?m)  (maxchargebattery))
        )
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
            (increase (at-robby ?m) (* #t (velocity ?m)))
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
    (:event switch_group
        :parameters (?g - group )
        :precondition (and (= (elementspergroup ?g) 0) (= (numofgroup ?g) (currentgroup)) (currentgroupset))
        :effect (and (not (currentgroupset)))
    )
    ; for picking up stray balls
    (:action pickup
        :parameters (?m - mover ?b - ball )
        :precondition (and
            (not (moving ?m)) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0) (> (battery ?m) 0)
        )
        :effect (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (free ?m))
            (assign (velocity ?m) (/ (* (position ?b) (weight ?b)) 100))
        )
    )
    ; for setting new groups or following previously-set groups
    (:action pickup_per_gruppo
        :parameters (?m - mover ?b - ball ?g - group)
        :precondition (and
            (not (moving ?m)) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
            (= (belong ?b) (numofgroup ?g)) (> (belong ?b) 0) (> (battery ?m) 0)
            (or 
                (not (currentgroupset))
                (and (= (belong ?b) (currentgroup)) (> (currentgroup) 0) (currentgroupset))
            )
        )
        :effect (and
            (assign (currentgroup) (belong ?b)) 
            (currentgroupset) 
            (decrease (elementspergroup ?g) 1) 
            (moving ?m) 
            (not (topositive ?m)) 
            (carry ?b ?m) 
            (not (free ?m))
            (assign (velocity ?m) (/ (* (position ?b) (weight ?b)) 100))
        )
    )

    ; (:event doneload
    ;     :parameters (?b - ball ?m - mover)
    ;     :precondition (and 
    ;         (carry ?b ?m) (not (free ?m))
    ;     )
    ;     :effect (and (isloaded ?b) (not (carry ?b ?m)) (free ?m) 
    ;         (assign (at-robby ?m) 0)
    ;         (assign (position ?b) 0)
    ;         (not (moving ?m))
    ;         (topositive ?m)
    ;     )
    ; )
    
    
    (:action pickup_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball)
        :precondition (and
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (at-robby ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (at-robby ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
            (> (battery ?m1) 0) (> (battery ?m2) 0)

            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0)
        )
        :effect (and
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) 150))
            (assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) 150))
        )
    )
    (:action pickup_by_two_per_gruppo
        :parameters (?m1 - mover ?m2 - mover ?b - ball ?g - group)
        :precondition (and
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (at-robby ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (at-robby ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
            (> (battery ?m1) 0) (> (battery ?m2) 0)

            (= (belong ?b) (numofgroup ?g)) (> (belong ?b) 0)
            (or 
                (not (currentgroupset))
                (and (= (belong ?b) (currentgroup)) (> (currentgroup) 0) (currentgroupset))
            )
        )
        :effect (and
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) 150))
            (assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) 150))
            (assign (currentgroup) (belong ?b)) 
            (currentgroupset) 
            (decrease (elementspergroup ?g) 1) 
        )
    )
    (:process backto_loader
        :parameters (?m - mover ?b - ball)
        :precondition (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (> (at-robby ?m) 0) (>(position ?b)0)(<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (decrease (at-robby ?m) (* #t (velocity ?m))) (decrease (position ?b) (* #t (velocity ?m)))
        )
    )
    (:process backto_loader_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball)
        :precondition (and
            (not (equal ?m1 ?m2))
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (> (at-robby ?m1) 0) 
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (> (at-robby ?m2) 0)
            (> (position ?b) 0)
        )
        :effect (and
            (decrease (at-robby ?m1) (* #t (velocity ?m1))) (decrease (at-robby ?m2) (* #t (velocity ?m2)))
            (decrease (position ?b) (* #t (velocity ?m1)))
        )
    )

    (:event stop_handover
        :parameters (?m - mover ?b - ball ?l - loader)
        :precondition (and
            (<= (at-robby ?m) 0) (<= (position ?b) 0) (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (busyloading ?l ?b)) (<= (weight ?b) 50) (not (isfragile ?b))
        )
        :effect (and
            (not (moving ?m)) (topositive ?m) (not (carry ?b ?m)) (busyloading ?l ?b) (free ?m)
            (assign (at-robby ?m) 0) (assign (position ?b) 0)
            (assign (velocity ?m) (max_vel ?m))
        )
    )
    (:event stop_handover_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball ?l - loader)
        :precondition (and
            (not (equal ?m1 ?m2))
            (<= (at-robby ?m1) 0) (<= (position ?b) 0) (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1)
            (<= (at-robby ?m2) 0) (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (or (not (ischeap ?l)) (<= (weight ?b) 50))
            (not (busyloading ?l ?b))
        )
        :effect (and
            (not (moving ?m1)) (topositive ?m1) (not (carry ?b ?m1)) (free ?m1) 
            (not (moving ?m2)) (topositive ?m2) (not (carry ?b ?m2)) (free ?m2)
            (busyloading ?l ?b)
            (assign (at-robby ?m1) 0) (assign (at-robby ?m2) 0) (assign (position ?b) 0)
            (assign (velocity ?m1) (max_vel ?m1))
            (assign (velocity ?m2) (max_vel ?m2))
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

