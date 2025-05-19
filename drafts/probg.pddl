(define (problem gripper-problem)
    (:domain gripper-continuous)

    (:objects
        mover1 mover2 - mover
        crate1 crate2 crate3 crate4 crate5 - crate
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
        
        (= (rob_position mover1) 0)  
        ; (= (velocity mover1) 6)
        (= (rob_position mover2) 0)  
        ; (= (velocity mover2) 6)
        
        (not (moving mover1))
        (not (moving mover2))
        
        (crate crate1)
        (crate crate2)
        (crate crate3)
        (crate crate4)
        (crate crate5)
        (not (isloaded crate1))
        (not (isloaded crate2))
        (not (isloaded crate3))
        (not (isloaded crate4))
        (isloaded crate5)
        (= (position crate1) 10)
        (= (position crate2) 20)
        (= (position crate3) 30)
        (= (position crate4) 40)
        (= (position crate5) 40)
        (= (weight crate1) 7)
        (= (weight crate2) 90)
        (= (weight crate3) 2)
        (= (weight crate4) 6)
        (= (weight crate5) 7)
        (not (isfragile crate1))
        (not (isfragile crate2))
        (not (isfragile crate3))
        (isfragile crate4)
        (not (isfragile crate5))
        
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
        (belongtogroup crate1 groupA)
        (belongtogroup crate2 groupA)
        (belongtogroup crate3 groupB)
        (belongtogroup crate4 groupB)
        (hasgoup crate1)
        (hasgoup crate2)
        (hasgoup crate3)
        (hasgoup crate4)
        (not(hasgoup crate5))



    )

    (:goal
        (and 
            (isloaded crate1)
            (isloaded crate2)
            (isloaded crate3)
            (isloaded crate4)
            (isloaded crate5)
        )
    )

)