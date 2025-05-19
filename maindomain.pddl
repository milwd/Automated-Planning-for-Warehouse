(define (domain gripper-continuous)
    ; (:requirements :conditional-effects :typing :strips :fluents :processes :events)

    (:types mover loader crate group)

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
        (currentgroupset)
        (freeloader ?l - loader)
        (at_company ?b - crate)
        (coeff_set)
    )

    (:functions
        (velocity ?m - mover)
        (max_vel ?m - mover)
        (rob_position ?m - mover)
        (position ?b - crate)
        (loadertimer ?l - loader)
        (weight ?b - crate)
        (belong ?b - crate)
        (currentgroup)
        (numofgroup ?g - group)
        (elementspergroup ?g - group)
        (battery ?m - mover)
        (maxbattery)
    )

    (:process drain_battery
        :parameters (?m - mover)
        :precondition (and
            (moving ?m) (> (battery ?m) 0)(>(rob_position ?m)1)
        )
        :effect (decrease (battery ?m) (* #t 1)
        )
    )
    (:event charging_battery
        :parameters (?m - mover)
        :precondition (and
            (not(moving ?m))(=(rob_position ?m)0) (< (battery ?m) (maxbattery))(free ?m)
        )
        :effect (and
            (assign (battery ?m)  (maxbattery))
        )
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
            (increase (rob_position ?m) (* #t (velocity ?m)))
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
    
    ; for picking up stray crates
    (:action pickup
        :parameters (?m - mover ?b - crate )
        :precondition (and
            (not (moving ?m)) (topositive ?m) (= (rob_position ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0)
            (> (battery ?m) 0)
            (at_company ?b)
        )
        :effect (and
            (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (free ?m))
            (assign (velocity ?m) (/ 100 (weight ?b)))
            ;(assign (velocity ?m) (/ (* (position ?b) (weight ?b)) 100))
            (not (at_company ?b))
        )
    )
    ; for setting new groups or following previously-set groups
    (:action pickup_per_gruppo
        :parameters (?m - mover ?b - crate ?g - group)
        :precondition (and
            (> (battery ?m) 0)
            (not (moving ?m)) (topositive ?m) (= (rob_position ?m) (position ?b)) (not (isloaded ?b)) (> (position ?b) 0) (<= (weight ?b) 50) (not (isfragile ?b)) (free ?m)
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
            (assign (velocity ?m) (/ 100 (weight ?b)))
            ;(assign (velocity ?m) (/ (* (position ?b) (weight ?b)) 100))
            (not (at_company ?b))
        )
    )
    
    (:action pickup_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - crate)
        :precondition (and
            (> (battery ?m1) 0)
            (> (battery ?m2) 0)
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (rob_position ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (rob_position ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
            (not (currentgroupset)) (= (belong ?b) 0) (= (currentgroup) 0)
            (at_company ?b)(not (coeff_set))
        )
        :effect (and        
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (not (at_company ?b))
            (coeff_set)
        )
    )
    (:action pickup_by_two_per_gruppo
        :parameters (?m1 - mover ?m2 - mover ?b - crate ?g - group)
        :precondition (and
            (> (battery ?m1) 0)
            (> (battery ?m2) 0)
            (not (equal ?m1 ?m2)) (free ?m1) (free ?m2)
            (not (moving ?m1)) (topositive ?m1) (= (rob_position ?m1) (position ?b))
            (not (moving ?m2)) (topositive ?m2) (= (rob_position ?m2) (position ?b)) 
            (not (isloaded ?b)) (> (position ?b) 0)
            (= (belong ?b) (numofgroup ?g)) (> (belong ?b) 0) 
            (or (not (currentgroupset)) (= (belong ?b) (currentgroup)))
            (at_company ?b) 
            (not (coeff_set))
        )
        :effect (and        
            (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1) (not (free ?m1))
            (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (not (free ?m2))
            (assign (currentgroup) (belong ?b)) 
            (currentgroupset) 
            (decrease (elementspergroup ?g) 1) 
            (not (at_company ?b))
            (coeff_set)

        )
    )

    (:event coeff_changer_light
        :parameters(?m1 - mover ?m2 - mover ?b - crate)
        :precondition (and (coeff_set) (carry ?b ?m1) (carry ?b ?m2) (not (equal ?m1 ?m2)) (< (weight ?b) 50))
        :effect(and
            (assign (velocity ?m1) (/ 150 (weight ?b)))
            (assign (velocity ?m2) (/ 150 (weight ?b)))
            ;(assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) 150))
            ;(assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) 150))
            (not(coeff_set))
        )
    )

    (:event coeff_changer_heavy
        :parameters(?m1 - mover ?m2 - mover ?b - crate)
        :precondition (and (coeff_set) (carry ?b ?m1) (carry ?b ?m2) (not (equal ?m1 ?m2)) (>= (weight ?b) 50))
        :effect(and
            (assign (velocity ?m1) (/ 100 (weight ?b)))
            (assign (velocity ?m2) (/ 100 (weight ?b)))
            ; (assign (velocity ?m1) (/ (* (position ?b) (weight ?b)) 100))
            ; (assign (velocity ?m2) (/ (* (position ?b) (weight ?b)) 100))
            (not(coeff_set))
        )
    )

    (:process backto_loader
        :parameters (?m - mover ?b - crate)
        :precondition (and
            (> (battery ?m) 0)
            (moving ?m) (not (topositive ?m)) 
            (carry ?b ?m) 
            (> (rob_position ?m) 0) 
            (>(position ?b)0) 
            (not (free ?m))
        )
        :effect (and
            (decrease (rob_position ?m) (* #t (velocity ?m)))
        )
    )

    (:action stop_handover
        :parameters (?m - mover ?b - crate ?l - loader)
        :precondition (and
            (<= (rob_position ?m) 0) (moving ?m) (not (topositive ?m)) (carry ?b ?m) (not (busyloading ?l ?b)) (<= (weight ?b) 50) (not (isfragile ?b))
            (or 
                (and (= (belong ?b) 0) ) ; (not (currentgroupset)) can be added, it's correct but may reduce parallelism 
                (and (> (belong ?b) 0) (= (belong ?b) (currentgroup)))
            )
        )
        :effect (and
            (not (moving ?m)) (topositive ?m) (not (carry ?b ?m)) (busyloading ?l ?b) (free ?m)
            (assign (rob_position ?m) 0) (assign (position ?b) 0)
            (assign (velocity ?m) (max_vel ?m))
            (not (freeloader ?l))

        )
    )
    (:action stop_handover_by_two
        :parameters (?m1 - mover ?m2 - mover ?b - crate ?l - loader)
        :precondition (and
            (not (equal ?m1 ?m2))
            (<= (rob_position ?m1) 0) (moving ?m1) (not (topositive ?m1)) (carry ?b ?m1)
            (<= (rob_position ?m2) 0) (moving ?m2) (not (topositive ?m2)) (carry ?b ?m2) (or (not (ischeap ?l)) (<= (weight ?b) 50))
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
            (assign (rob_position ?m1) 0) (assign (rob_position ?m2) 0) (assign (position ?b) 0)
            (assign (velocity ?m1) (max_vel ?m1))
            (assign (velocity ?m2) (max_vel ?m2))
            ; (assign (x) 100)
            (not (freeloader ?l))

        )
    )
    (:process load
        :parameters (?l - loader ?b - crate)
        :precondition (and 
            (busyloading ?l ?b) 
            (not (freeloader ?l))
            (or (and (< (loadertimer ?l) 4) (not (isfragile ?b))) (and (< (loadertimer ?l) 6) (isfragile ?b))) 
        )
        :effect (increase (loadertimer ?l) (* #t 1))
    )
    (:event doneload
        :parameters (?b - crate ?l - loader)
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
