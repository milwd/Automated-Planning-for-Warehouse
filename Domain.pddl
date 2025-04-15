(define (domain gripper-strips)
   (:predicates (room ?r)
        (ball ?b)
        (gripper ?g)
        (at-robby ?r)
        (at ?b ?r)
        (free ?g)
        (free2 ?g)
        (carry ?o ?g)
        (connected ?r1 ?r2))

   (:action move
       :parameters (?from ?to)
       :precondition (and (room ?from) (room ?to) (connected ?to ?from) (at-robby ?from))
       :effect (and (at-robby ?to)
             (not (at-robby ?from))))


   (:action pick
       :parameters (?obj ?room ?gripper)
       :precondition (and (ball ?obj) (room ?room) (gripper ?gripper)
                (at ?obj ?room) (at-robby ?room) (free ?gripper) (free2 ?gripper))
       :effect (and (carry ?obj ?gripper)
            (not (at ?obj ?room)) 
            (not (free ?gripper))))
            
 (:action pick2
       :parameters (?obj ?room ?gripper)
       :precondition (and (ball ?obj) (room ?room) (gripper ?gripper)
                (at ?obj ?room) (at-robby ?room) (not (free ?gripper)) (free2 ?gripper))
       :effect (and (carry ?obj ?gripper)
            (not (at ?obj ?room)) 
            (not (free2 ?gripper))))


   (:action drop
       :parameters (?obj ?room ?gripper)
       :precondition (and (ball ?obj) (room ?room) (gripper ?gripper)
                (carry ?obj ?gripper) (at-robby ?room) (free2 ?gripper))
       :effect (and (at ?obj ?room)
            (free ?gripper)
            (not (carry ?obj ?gripper))))
            
    (:action drop2
       :parameters (?obj ?room ?gripper)
       :precondition (and (ball ?obj) (room ?room) (gripper ?gripper)
                (carry ?obj ?gripper) (at-robby ?room) (not (free2 ?gripper)) (not (free ?gripper)))
       :effect (and (at ?obj ?room)
            (free2 ?gripper)
            (not (carry ?obj ?gripper)))))