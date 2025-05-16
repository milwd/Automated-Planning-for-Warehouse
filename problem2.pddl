(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        ball1 ball2 ball3 ball4 - ball
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
        (ball ball4)
        (not (isloaded ball1))
        (not (isloaded ball2))
        (not (isloaded ball3))
        (not (isloaded ball4))
        (at_company ball1)
        (at_company ball2)
        (at_company ball3)
        (at_company ball4)
        (= (position ball1) 10)
        (= (position ball2) 20)
        (= (position ball3) 20)
        (= (position ball4) 10)
        (= (weight ball1) 70)
        (= (weight ball2) 80)
        (= (weight ball3) 20)
        (= (weight ball4) 30)
        (not (isfragile ball1))
        (isfragile ball2)
        (not (isfragile ball3))
        (not (isfragile ball4))
        (= (belong ball1) 1)
        (= (belong ball2) 1)
        (= (belong ball3) 2)
        (= (belong ball4) 2)
        (= (x) 100)
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
            (isloaded ball4)
        )
    )

    ; (:metric minimize (total-time))

)
