
# Table of Contents

1.  [Assignment](#orgaed705d)
    1.  [System](#org76c3023)
    2.  [Exercises](#orgf136256)
        1.  [Implement a set of rules of in CLIPS for SRLC](#org20b5f2f)
        2.  [Implement a set of rules of in CLIPS for SRC](#org72dbcbf)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org7d51674)
    3.  [Delivery](#orgc4bef3e)
2.  [Structure](#org0258c8b)
    1.  [Code](#org2fb50d8)
    2.  [Notes](#org95bae97)



<a id="orgaed705d"></a>

# Assignment


<a id="org76c3023"></a>

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


<a id="orgf136256"></a>

## Exercises


<a id="org20b5f2f"></a>

### DONE Implement a set of rules of in CLIPS for SRLC


<a id="org72dbcbf"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org7d51674"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orgc4bef3e"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="org0258c8b"></a>

# Structure


<a id="org2fb50d8"></a>

## Code

-   **`crc.clp`:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **`srlc.clp`:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **`src.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **`bonus_src_queue.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="org95bae97"></a>

## Notes

-   **`assignment.pdf`:** Original text of the assignment
-   **`delivery.pdf`:** Delivery document
