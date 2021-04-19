
# Table of Contents

1.  [System](#orgaa9ade2)
2.  [Exercises](#org8efdad3)
3.  [Delivery](#org50e5159)



<a id="orgaa9ade2"></a>

# System

![img](./crc-policies.jpg "A crossing road control (CRC) can implement two policies: straight-right crossing (SRC) or straight-right-left crossing (SRC).")

The two policies implement the following permission to cross rules

-   **SRLC:** FIFO
-   **SRC:** On rotation, permission goes either to cars from N&S or from E&W
    -   If it is the N&S turn, `n` cars from N and `n` cars from S receive the permission to go
    -   If there are `m<n` cars waiting from one direction, only `m` orders are sent
    -   If zero cars are waiting to cross, the turn goes to E&W (and vice versa)
    -   If a car crosses, it notifies the crossing to the system


<a id="org8efdad3"></a>

# Exercises

1.  Implement a set of rules of in CLIPS for SRLC
2.  Implement a set of rules of in CLIPS for SRC
3.  Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="org50e5159"></a>

# Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC
