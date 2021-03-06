
# Table of Contents

1.  [Assignment](#org5b99c6d)
    1.  [System](#org345739d)
    2.  [Exercises](#org413de77)
        1.  [Implement a set of rules of in CLIPS for SRLC](#org4c429da)
        2.  [Implement a set of rules of in CLIPS for SRC](#org19abd88)
        3.  [Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC](#org684ae6b)
    3.  [Delivery](#orgd4f876a)
2.  [Structure](#org88aca1c)
    1.  [Code](#org9ac5b28)
    2.  [Notes](#org284c0d3)



<a id="org5b99c6d"></a>

# Assignment


<a id="org345739d"></a>

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


<a id="org413de77"></a>

## Exercises


<a id="org4c429da"></a>

### DONE Implement a set of rules of in CLIPS for SRLC

The approach adopted for this implementation is to first define the CRC system. This means answering

-   **Policy:** SRLC or SRC?
-   **(Number of) incoming cars:** How many cars come into the system at a time?
-   **(Number of) outgoing cars:** How many cars go out of the system at a time?
-   **Turn:** That is, how many cars crossed the system from its start?
-   **Time:** What time is it? (This differes from the number of turns when the time to cross is non-zero)
-   **Time-to-cross:** How much time is needed by a car to cross?

While these settings must be set at the beginning, they can be changed at any time later.

With the previous settings provided, a flag system is adopted to enable the user to trigger

-   **Traffic generation:** A fixed number of cars is asserted into the KB. The arrival and departure directions of the car is randomly set, however it is constrained to respect the policy previously agreed. The random generation uses a random seed to guarantee the reproducibility of experiments.
-   **Traffic departure:** The crossing of a car doesn&rsquo;t imply the removal of its assertion from the KB, but rather changing its state. This choice allows to have a log of the system from the start of its execution at any time.

Some limitations of the current implementation are the following

-   The time-to-cross is equal for every car: while it can be viewed as a fixed maximum slot of time that is guaranteed a priori to any car, it might be more efficient in a realistic scenario to let the next car cross as soon as the current car actually completes the crossing.
-   Even if this is the SRLC implementation, the SRC option for the policy is left available. However it is taken into account only for the traffic generation: the departure is always FIFO.
-   If a small amount of incoming and outgoing cars is set, the mechanism of flags to generate and manage traffic can be quite tedious for the user.


<a id="org19abd88"></a>

### DONE Implement a set of rules of in CLIPS for SRC


<a id="org684ae6b"></a>

### DONE Implement the random arrival of cars from any direction to check the correct behaviour in SRLC and SRC


<a id="orgd4f876a"></a>

## Delivery

-   PDF document with
    -   **Main page:** Members of the group + Practice title
    -   **Description of the KB:** For both SRC and SRLC
    -   **Capture of correct execution:** For both SRC and SRLC
-   Text file with the code for both SRC and SRLC


<a id="org88aca1c"></a>

# Structure


<a id="org9ac5b28"></a>

## Code

-   **`crc.clp`:** Generic logic for traffic generation in a CRC for both SRC and SRLC
-   **`srlc.clp`:** Logic for traffic generation and crossing in a CRC with SRLC policy
-   **`src.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy
-   **`bonus_src_queue.clp`:** Logic for traffic generation and crossing in a CRC with SRC policy using queues


<a id="org284c0d3"></a>

## Notes

-   **`assignment.pdf`:** Original text of the assignment
-   **`delivery.pdf`:** Delivery document
