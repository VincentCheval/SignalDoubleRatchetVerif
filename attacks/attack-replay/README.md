## Explanation of the trace pdf

This will be an attack on forward secrecy, as a message key compromise in one session will lead to the attacker possessing a message key used in a different session.

We have an honest session initiated by Alice (Beginning of process AliceDoubleRatchet) which, due to replay, corresponds to two sessions with Bob, with session ids *s_id_4*, *s_id_3*.

*s_id_3*:
In *s_id_3*, a message *(Header(a_3,0,a_4),a_5)* is received by Bob from the attacker. In the process of decrypting this, the first message key is skipped over (the block beginning with {371} event in *s_id_3*s tree), resulting in the inserted message key *~M_6 = kdf_ck_message(kdf_rk_chain(SK_4,SMUL(dh_scal(s_11),a_3)))*, which should decrypt the initial message sent by Alice (under normal execution).
The attacker compromises the message key store (the block beginning with {668}) and learns this key value.

*s_id_4*:
In *s_id_4*, a message encrypted with the message key *~M_6* is sent to Bob from the attacker (this is the communication *~X_3*). 
Seperately, Bob has skipped their first message key (the block under *s_id_4* beginning {371}) and placed it in the message store. Since the starting key values for *s_id_4, s_id_3* were the same, this first message key is *~M_6*. 
Bob uses this stored message key to decrypt the received message (the block under *s_id_4* beginning {432}).

This results in the red box labelled {440}, the message key *~M_6* was used by Bob in *s_id_4*, and the attacker knew the value of *~M_6* through compromises in *s_id_4*. This breaks forward secrecy.