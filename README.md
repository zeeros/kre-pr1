
# Table of Contents

1.  [System](#org673eada)
2.  [Exercises](#org77ce990)
    1.  [Implement a set of rules of in CLIPS for SRLC](#org15d1b54)
    2.  [Implement a set of rules of in CLIPS for SRC](#orgfbd4c69)
    3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org85d72fe)
3.  [Delivery](#orga9f2f3e)



<a id="org673eada"></a>

# System

We consider a crossing road control (CRC) that manages cars coming from north south, east and west.

![img](./crc-policies.jpg "A crossing road control (CRC) can implement two policies: straight-right crossing (SRC) or straight-right-left crossing (SRC).")

The two policies implement the following permission to cross rules

-   **SRLC:** FIFO
-   **SRC:** On rotation, permission goes either to cars from N&S or from E&W
    -   If it is the N&S turn, `n` cars from N and `n` cars from S receive the permission to go
    -   If there are `m<n` cars waiting from one direction, only `m` orders are sent
    -   If zero cars are waiting to cross, the turn goes to E&W (and vice versa)
    -   If a car crosses, it notifies the crossing to the system


<a id="org77ce990"></a>

# Exercises


<a id="org15d1b54"></a>

## DONE Implement a set of rules of in CLIPS for SRLC


<a id="orgfbd4c69"></a>

## DONE Implement a set of rules of in CLIPS for SRC


<a id="org85d72fe"></a>

## DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orga9f2f3e"></a>

# Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC
