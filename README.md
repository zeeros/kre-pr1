
# Table of Contents

1.  [Assignment](#org0326f2e)
    1.  [System](#org001bd7a)
    2.  [Exercises](#org88a8cc5)
        1.  [Implement a set of rules of in CLIPS for SRLC](#orgc4a2c2c)
        2.  [Implement a set of rules of in CLIPS for SRC](#org8ef958e)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org6452b36)
    3.  [Delivery](#orgd81aad0)
2.  [Structure](#orgb12fe18)
    1.  [Code](#org181e6dd)
    2.  [Notes](#orgc2b10c3)



<a id="org0326f2e"></a>

# Assignment


<a id="org001bd7a"></a>

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


<a id="org88a8cc5"></a>

## Exercises


<a id="orgc4a2c2c"></a>

### DONE Implement a set of rules of in CLIPS for SRLC


<a id="org8ef958e"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org6452b36"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orgd81aad0"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="orgb12fe18"></a>

# Structure


<a id="org181e6dd"></a>

## Code

-   **`crc.clp`:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **`srlc.clp`:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **`src.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **`bonus_src_queue.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="orgc2b10c3"></a>

## Notes

-   **assignment.pdf:** Original text of the assignment
