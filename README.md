
# Note:

This is not ready yet.

# Moron\_Text

Takes a string and run it as an app:

    ON : any wrong answer
    SHOW PICTURE : http://www..../failure.jpg

    ON : final right answer

    You got it! Wait while I show you your secret
    admirer.

    Please wait a few seconds:

    WAIT AND SHOW CLOCK : 5 secs
    GO TO : http://www../admirer

    CHOOSE ONE : first-guess
    What is your favorite fruit:
    ( ) apple
    ( ) blueberry
    (o) strawberry
    ( ) orange

    CHOOSE ONE : second-guess
    What is your favorite location:
    ( ) beach
    (o) picnic
    ( ) Osaka
    ( ) Benton

    CHOOSE ONE : third-guess
    What is your favorite book:
    ( ) 1
    (o) 2
    ( ) 3
    ( ) 4



# Another example:

Save stuff to the datastore and use it in the code:

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

    BUTTON : SEND

    WHEN : Other: [---]
    Cool... I never heard of ^X.



## Installation

    gem 'moron_text'

