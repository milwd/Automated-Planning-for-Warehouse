
; == CONTINUOUS WITH LOADER TIME ===============================================

(define (domain gripper-continuous)
    ; (:requirements :conditional-effects :typing :strips :fluents :processes :events)

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
        (freeloader ?l - loader)
        (at_company ?b - ball)
    )

    (:functions
        (x)
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
        (maxbattery)
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
            (not(moving ?m))(=(at-robby ?m)0) (< (battery ?m) (maxbattery))(free ?m)
        )
        :effect (and
            (assign (battery ?m)  (maxbattery))
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
        :precondition (and 
            (= (elementspergroup ?g) 0) 
            (= (numofgroup ?g) 
            (currentgroup)) 
            (currentgroupset)
        )
        :effect (and (not (currentgroupset)))
    )
    
    ; for picking up stray balls
    (:action pickup
        :parameters (?m - mover ?b - ball )
        :precondition (and
            (not (moving ?m)) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0)
            (> (battery ?m) 0)
            (at_company ?b)
        )
        :effect (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (free ?m))
            (assign (velocity ?m) (/ (* (position ?b) (weight ?b)) 100))
            (not (at_company ?b))
        )
    )
    ; for setting new groups or following previously-set groups
    (:action pickup_per_gruppo
        :parameters (?m - mover ?b - ball ?g - group)
        :precondition (and
            (> (battery ?m) 0)
            (not (moving ?m)) (topositive ?m) (= (at-robby ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
            (= (belong ?b) (numofgroup ?g)) (> (belong ?b) 0)
            (or (not (currentgroupset)) (= (belong ?b) (currentgroup)) )
            (at_company ?b)
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
            (not (at_company ?b))
        )
    )
    
    (:action pickup_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball)
        :precondition (and
            (> (battery ?m1) 0)
            (> (battery ?m2) 0)
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (at-robby ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (at-robby ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)

            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0)
            (at_company ?b)
        )
        :effect (and
            ; (when (<= (weight ?b) 50) (assign (x) 150))
            (assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) x))
            (assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) x))            
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (not (at_company ?b))
        )
    )
    (:action pickup_by_two_per_gruppo
        :parameters (?m1 - mover ?m2 - mover ?b - ball ?g - group)
        :precondition (and
            (> (battery ?m1) 0)
            (> (battery ?m2) 0)
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (at-robby ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (at-robby ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)

            (= (belong ?b) (numofgroup ?g)) (> (belong ?b) 0) 
            (or (not (currentgroupset)) (= (belong ?b) (currentgroup)))
            (at_company ?b)
        )
        :effect (and
            ; (when (<= (weight ?b) 50) (assign (x) 150))
            (assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) x))
            (assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) x))             
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (assign (currentgroup) (belong ?b)) 
            (currentgroupset) 
            (decrease (elementspergroup ?g) 1) 
            (not (at_company ?b))
        )
    )
    (:process backto_loader
        :parameters (?m - mover ?b - ball)
        :precondition (and
            (> (battery ?m) 0)
            (moving ?m) (not (topositive ?m)) 
            (carry ?b ?m) 
            (> (at-robby ?m) 0) 
            (>(position ?b)0) 
            (not (free ?m))
        )
        :effect (and
            (decrease (at-robby ?m) (* #t (velocity ?m)))
        )
    )

    (:action stop_handover
        :parameters (?m - mover ?b - ball ?l - loader)
        :precondition (and
            (<= (at-robby ?m) 0) (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (busyloading ?l ?b)) (<= (weight ?b) 50) (not (isfragile ?b))
            (or 
                (and (= (belong ?b) 0) ) ; (not (currentgroupset)) can be added, it's correct but may reduce parallelism 
                (and (> (belong ?b) 0) (= (belong ?b) (currentgroup)))
            )
        )
        :effect (and
            (not (moving ?m)) (topositive ?m) (not (carry ?b ?m)) (busyloading ?l ?b) (free ?m)
            (assign (at-robby ?m) 0) (assign (position ?b) 0)
            (assign (velocity ?m) (max_vel ?m))
            (not (freeloader ?l))

        )
    )
    (:action stop_handover_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - ball ?l - loader)
        :precondition (and
            (not (equal ?m1 ?m2))
            (<= (at-robby ?m1) 0) (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1)
            (<= (at-robby ?m2) 0) (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (or (not (ischeap ?l)) (<= (weight ?b) 50))
            (not (busyloading ?l ?b))
            (or 
                (and (= (belong ?b) 0) ) ; (not (currentgroupset)) can be added, it's correct but may reduce parallelism 
                (and (> (belong ?b) 0) (= (belong ?b) (currentgroup)))
            )
        )
        :effect (and
            (not (moving ?m1)) (topositive ?m1) (not (carry ?b ?m1)) (free ?m1) 
            (not (moving ?m2)) (topositive ?m2) (not (carry ?b ?m2)) (free ?m2)
            (busyloading ?l ?b)
            (assign (at-robby ?m1) 0) (assign (at-robby ?m2) 0) (assign (position ?b) 0)
            (assign (velocity ?m1) (max_vel ?m1))
            (assign (velocity ?m2) (max_vel ?m2))
            (assign (x) 100)
            (not (freeloader ?l))

        )
    )
    (:process load
        :parameters (?l - loader ?b - ball)
        :precondition (and 
            (busyloading ?l ?b) 
            (not (freeloader ?l))
            (or (and (< (loadertimer ?l) 4) (not (isfragile ?b))) (and (< (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (increase (loadertimer ?l) (* #t 1))
    )
    (:event doneload
        :parameters (?b - ball ?l - loader)
        :precondition (and 
            (busyloading ?l ?b)
            (not (freeloader ?l))
            (or (and (= (loadertimer ?l) 4) (not (isfragile ?b))) (and (= (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (and 
            (freeloader ?l)
            (assign (loadertimer ?l) 0) (not (busyloading ?l ?b)) (isloaded ?b) 
        )
    )
       
)
