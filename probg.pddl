(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        ball1 ball2 ball3 ball4 ball5 - ball
        loader1 loader2 - loader
        groupA groupB - group 
    )

    (:init
        (mover mover1)
        (mover mover2)
        (free mover1)
        (free mover2)
        (= (velocity) 1)
        (equal mover1 mover1)
        (equal mover2 mover2)
        
        ; (= (max_vel mover1) 6)
        ; (= (max_vel mover2) 6)
        
        (= (at-robby mover1) 0)  
        ; (= (velocity mover1) 6)
        (= (at-robby mover2) 0)  
        ; (= (velocity mover2) 6)
        
        (not (moving mover1))
        (not (moving mover2))
        
        (ball ball1)
        (ball ball2)
        (ball ball3)
        (ball ball4)
        (ball ball5)
        (not (isloaded ball1))
        (not (isloaded ball2))
        (not (isloaded ball3))
        (not (isloaded ball4))
        (isloaded ball5)
        (= (position ball1) 10)
        (= (position ball2) 20)
        (= (position ball3) 30)
        (= (position ball4) 40)
        (= (position ball5) 40)
        (= (weight ball1) 7)
        (= (weight ball2) 90)
        (= (weight ball3) 2)
        (= (weight ball4) 6)
        (= (weight ball5) 7)
        (not (isfragile ball1))
        (not (isfragile ball2))
        (not (isfragile ball3))
        (isfragile ball4)
        (not (isfragile ball5))
        
        (loader loader1)
        (= (loadertimer loader1) 0)
        (not (busyloading loader1)) 
        (loader loader2)
        (= (loadertimer loader2) 0)
        (not (busyloading loader2)) 
        (not (ischeap loader2))
        (not (ischeap loader1))

        (group groupA)
        (group groupB)
        (belongtogroup ball1 groupA)
        (belongtogroup ball2 groupA)
        (belongtogroup ball3 groupB)
        (belongtogroup ball4 groupB)
        (hasgoup ball1)
        (hasgoup ball2)
        (hasgoup ball3)
        (hasgoup ball4)
        (not(hasgoup ball5))



    )

    (:goal
        (and 
            (isloaded ball1)
            (isloaded ball2)
            (isloaded ball3)
            (isloaded ball4)
            (isloaded ball5)
        )
    )

)