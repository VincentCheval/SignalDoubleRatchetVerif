## Explanation of the trace pdf

This is an attack on forward secrecy, as Bob will decrypt a message for which the attacker knows the message key, with no compromise having occurred. 

In the trace Bob initialises a double ratchet session (Beginning od process BobDoubleRatchet) as the responder. In this state his receiving chain key will be none-valued, as he should ratchet before decrypting any messages.

The attacker then sends a message to Bob *(Header(none_dh,a_6,0),a_7)*, where *a_7* is a ciphertext Bob should decrypt. 
Bob then immediately tries to decrypt the message (without ratcheting due to the *none_dh* value in the header).
Therefore he tries to decrypt *a_7* in the red box on the left with the message key *kdf_ck_message(none_ck)*, combined with some attacker controlled value *a_11* from the SPQR ratchet.

The attacker is able to construct both these values and thus the full message key *kdf_hybrid(kdf_ck_message(none_ck),a_11)*.