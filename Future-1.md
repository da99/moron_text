
# Syntax: 

    TEXT : InTRO

    In the far east corner of the Galos Building...

    TEXT : OuTRO ----------------
    We end with a swipe towards the past...
    !InTRO
    !POS
    --------------------------

    ABOUT : first-guess
    ON : apple
    |
    | PUT "100,100" into POS
    |
    | BLOCK : MOVE_CARD
    | | SET the location of card button x to POS
    | | ADD 15 to item 1 of POS
    | |---
    |
    | REPEAT with x = 1 to the number of card buttons
    | | MOVE_CARD .
    | | PLAY_HARD .
    | | DIE_HARD .
    | | LIVE_HARD .
    | |---
    |
    | REPEAT with x = 1 to the number of card buttons
    | | SET the location of card button x to POS
    | | ADD 15 to item 1 of POS
    | |---
    |
    | ADD 15 to item 1 of POS
    | ALERT : InTRO
    | OuTRO .
    | REPLACE : !POS POS
    | REPLACE : !InTRO InTRO
    | ALERT .
    |---

    ON FIRST TRUE :
    |
    | |---
    | | ARR size  > 2
    | |---
    | | DO SOMETHING .
    | |---
    |
    | |---
    | | ARR size < 5
    | |---
    | | DO SOMETHING ELSE.
    | |---
    |
    | |---
    | | DEFAULT .
    | |---
    |
    |---


