
## Example: Form that saves a record.

    Which is your favorite fruit?
    ( ) apple
     | I like apples too!
    ( ) orange
     | I hate oranges. Blah!
    ( ) round
     | ( ) prune
     | ( ) raisin
     | ( ) grapes
    MERGE : previous answers
    ( ) Other.
     |* Other: [___]

    { Send }

    WHEN : Other: [xxx]
    Cool... I never heard of ^X.

## Example: Arithmetic Calculator

    [|     STACK         |]
    { 0 ... 9 . }  || { + }
                   || { - }
                   || { * }
                   || { / }
    =======================
                      { = }

    ON : CLICK NUMBER
    VALUE -> [| STACK |] .
    " " -> [| STACK |] .

    ON : CLICK NON-ALPHA-NUM AND NOT =
    VALUE -> [| STACK |] .
    " " -> [| STACK |] .

    ON : CLICK =
    MATH-EVAL : LAST 3 .

## Example:

    ON : any wrong answer
    SHOW PICTURE : http://www..../failure.jpg

    ON : final right answer

    You got it! Wait while I show you your secret
    admirer.

    Please wait a few seconds:

    WAIT AND SHOW CLOCK : 5 secs
    GO TO : http://www../admirer
