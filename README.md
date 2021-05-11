
# Table of Contents

1.  [Assignment](#orgf115373)
    1.  [System](#org62651be)
    2.  [Exercises](#org0059825)
        1.  [Implement a set of rules of in CLIPS for SRLC](#org82a4cb0)
        2.  [Implement a set of rules of in CLIPS for SRC](#org32c0cd2)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org1afc76d)
    3.  [Delivery](#orgc9fd1a1)
2.  [Structure](#org46de90a)
    1.  [Code](#org0b85b4e)
    2.  [Notes](#orgdb81699)



<a id="orgf115373"></a>

# Assignment


<a id="org62651be"></a>

## System

We consider a crossing road control (CRC) that manages cars coming from north south, east and west.

![img](./crc-policies.jpg "A crossing road control (CRC) can implement two policies: straight-right crossing (SRC) or straight-right-left crossing (SRC).")

The two policies implement the following permission to cross rules

-   **SRLC:** FIFO
-   **SRC:** On rotation, permission goes either to cars from N&S or from E&W
    -   If it is the N&S turn, `n` cars from N and `n` cars from S receive the permission to go
    -   If there are `m<n` cars waiting from one direction, only `m` orders are sent
    -   If zero cars are waiting to cross, the turn goes to E&W (and vice versa)
    -   If a car crosses, it notifies the crossing to the system


<a id="org0059825"></a>

## Exercises


<a id="org82a4cb0"></a>

### DONE Implement a set of rules of in CLIPS for SRLC


<a id="org32c0cd2"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org1afc76d"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orgc9fd1a1"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="org46de90a"></a>

# Structure


<a id="org0b85b4e"></a>

## Code

-   **`crc.clp`:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **`srlc.clp`:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **`src.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **`bonus_src_queue.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="orgdb81699"></a>

## Notes

-   **assignment.pdf:** Original text of the assignment
-   **delivery.pdf:** Delivery document
