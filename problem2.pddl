(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        crate1 crate2 crate3 crate4 - crate
        loader1 loader2 - loader
        A B - group
    )

    (:init
        (mover mover1)
        (mover mover2)
        (free mover1)
        (free mover2)
        (equal mover1 mover1)
        (equal mover2 mover2)
        (= (rob_position mover1) 0)  
        (= (rob_position mover2) 0)  
        (not (moving mover1))
        (not (moving mover2))
        (= (battery mover1) 20)
        (= (battery mover2) 20)
        (= (maxbattery) 20)
        
        (= (max_vel mover1) 10)
        (= (max_vel mover2) 10)
        
        (= (velocity mover1) 10)
        (= (velocity mover2) 10)

        (not(coeff_set))
        
        (crate crate1)
        (crate crate2)
        (crate crate3)
        (crate crate4)
        (not (isloaded crate1))
        (not (isloaded crate2))
        (not (isloaded crate3))
        (not (isloaded crate4))
        (at_company crate1)
        (at_company crate2)
        (at_company crate3)
        (at_company crate4)
        (= (position crate1) 10)
        (= (position crate2) 20)
        (= (position crate3) 20)
        (= (position crate4) 10)
        (= (weight crate1) 70)
        (= (weight crate2) 80)
        (= (weight crate3) 20)
        (= (weight crate4) 30)
        (not (isfragile crate1))
        (isfragile crate2)
        (not (isfragile crate3))
        (not (isfragile crate4))
        (= (belong crate1) 1)
        (= (belong crate2) 1)
        (= (belong crate3) 2)
        (= (belong crate4) 2)
        (group A)
        (group B)
        (= (numofgroup A) 1)
        (= (numofgroup B) 2)
        
        (= (elementspergroup A) 2)
        (= (elementspergroup B) 2)
        
        (not (currentgroupset))
        (= (currentgroup) 0)

        (loader loader1)
        (loader loader2)
        (= (loadertimer loader1) 0)
        (= (loadertimer loader2) 0)
        (freeloader loader1)
        (freeloader loader2)
        (not (ischeap loader2))
        (ischeap loader1)

    )

    (:goal
        (and 
            (isloaded crate1)
            (isloaded crate2)
            (isloaded crate3)
            (isloaded crate4)
        )
    )

    ; (:metric minimize (total-time))

)
