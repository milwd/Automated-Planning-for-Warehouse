(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        ball1 ball2 ball3 ball4 - ball
        loader1 loader2 - loader
    )

    (:init
        (= (velocity) 1)

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
        
        (ball ball1)
        (ball ball2)
        (ball ball3)
        (ball ball4)
        (not (isloaded ball1))
        (not (isloaded ball2))
        (not (isloaded ball3))
        (not (isloaded ball4))
        (= (position ball1) 10)
        (= (position ball2) 20)
        (= (position ball3) 20)
        (= (position ball4) 10)
        (= (weight ball1) 70)
        (= (weight ball2) 80)
        (= (weight ball3) 20)
        (= (weight ball4) 30)
        
        (loader loader1)
        (= (loadertimer loader1) 0)
        (not (busyloading loader1)) 
        (loader loader2)
        (= (loadertimer loader2) 0)
        (not (busyloading loader2)) 
        (not (ischeap loader2))
        (not (ischeap loader1))
    )

    (:goal
        (and 
            (isloaded ball1)
            (isloaded ball2)
            (isloaded ball3)
            (isloaded ball4)
        )
    )

)