## Explanation of the trace pdf

This attack demonstrates that an SPK (a key used in PQXDH) can be leaked through compromises in the Double Ratchet, due to the existence of weak states. 

In this trace two PQXDH clients are launched, the first of these is unimportant (our trace is not minimal). The client *a_1* goes on to create an SPK in the red box {1233} valued *dh_scal(s_34)*. This client continues executing the PQXDH protocol and eventually launches their Double Ratchet (Beginning of process DoubleRatchet).

After launching this process, the event CompromiseDHs is executed (the bottom red box), with the corresponding DHs leaked being *dh_scal(34)*. This models the attacker compromising the state during the Double Ratchet. 

Since the leaked DHs was the same as the SPK, this demonstrates the above described attack.