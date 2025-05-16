(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        ball1 ball2 ball3 - ball
        loader1 loader2 - loader
        A - group
    )

    (:init
        (mover mover1)
        (mover mover2)
        (free mover1)
        (free mover2)
        (equal mover1 mover1)
        (equal mover2 mover2)
        (= (at-robby mover1) 0)  
        (= (at-robby mover2) 0)  
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
        
        (ball ball1)
        (ball ball2)
        (ball ball3)
        (not (isloaded ball1))
        (not (isloaded ball2))
        (not (isloaded ball3))
        (at_company ball1)
        (at_company ball2)
        (at_company ball3)
        (= (position ball1) 10)
        (= (position ball2) 20)
        (= (position ball3) 20)
        (= (weight ball1) 70)
        (= (weight ball2) 20)
        (= (weight ball3) 20)
        (not (isfragile ball1))
        (isfragile ball2)
        (not (isfragile ball3))
        (= (belong ball1) 0)
        (= (belong ball2) 1)
        (= (belong ball3) 1)
        (= (x) 100)
        (group A)
        (= (numofgroup A) 1)
        
        (= (elementspergroup A) 2)
        
        (not (currentgroupset))
        (= (currentgroup) 0)

        (loader loader1)
        (loader loader2)
        (= (loadertimer loader1) 0)
        (= (loadertimer loader2) 0)
        (not (busyloading loader1)) 
        (not (busyloading loader2)) 
        (not (ischeap loader2))
        (ischeap loader1)

        (freeloader loader1)
        (freeloader loader2)

    )

    (:goal
        (and 
            (isloaded ball1)
            (isloaded ball2)
            (isloaded ball3)
        )
    )

    ; (:metric minimize (total-time))

)
