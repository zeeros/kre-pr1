
# Table of Contents

1.  [Assignment](#orgf21206f)
    1.  [System](#org4fdf9c7)
    2.  [Exercises](#orga88095f)
        1.  [Implement a set of rules of in CLIPS for SRLC](#org77134e5)
        2.  [Implement a set of rules of in CLIPS for SRC](#orgc4f2a9a)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org12a9325)
    3.  [Delivery](#org73209d6)
2.  [Structure](#orgb347dfd)
    1.  [Code](#org667aec9)
    2.  [Notes](#orgfd26cba)



<a id="orgf21206f"></a>

# Assignment


<a id="org4fdf9c7"></a>

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


<a id="orga88095f"></a>

## Exercises


<a id="org77134e5"></a>

### DONE Implement a set of rules of in CLIPS for SRLC


<a id="orgc4f2a9a"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org12a9325"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="org73209d6"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="orgb347dfd"></a>

# Structure


<a id="org667aec9"></a>

## Code

-   **crc.clp:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **srlc.clp:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **src.clp:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **bonus\\<sub>src</sub>\\<sub>queue.clp</sub>:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="orgfd26cba"></a>

## Notes

-   **assignment.pdf:** Original text of the assignment
-   **delivery.pdf:** Delivery document
