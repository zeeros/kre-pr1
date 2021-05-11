
# Table of Contents

1.  [Assignment](#org8480f4a)
    1.  [System](#org3019444)
    2.  [Exercises](#orgf200aa3)
        1.  [Implement a set of rules of in CLIPS for SRLC](#org92e8efc)
        2.  [Implement a set of rules of in CLIPS for SRC](#org4312e72)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org3f82be4)
    3.  [Delivery](#orge66b82c)
2.  [Structure](#orgce2c104)
    1.  [Code](#org3488ca8)
    2.  [Notes](#org68848a7)



<a id="org8480f4a"></a>

# Assignment


<a id="org3019444"></a>

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


<a id="orgf200aa3"></a>

## Exercises


<a id="org92e8efc"></a>

### DONE Implement a set of rules of in CLIPS for SRLC


<a id="org4312e72"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org3f82be4"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orge66b82c"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="orgce2c104"></a>

# Structure


<a id="org3488ca8"></a>

## Code

-   **crc.clp:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **srlc.clp:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **src.clp:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **bonus<sub>src</sub><sub>queue.clp</sub>:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="org68848a7"></a>

## Notes

-   **assignment.pdf:** Original text of the assignment
-   **delivery.pdf:** Delivery document
