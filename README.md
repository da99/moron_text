
# Note:

This is not ready yet.

# Moron_Text

Takes a string and run it as an app:

    ON : any wrong answer
    SHOW PICTURE : http://www..../failure.jpg

    ON : final right answer

    You got it! Wait while I show you your secret
    admirer.

    Please wait a few seconds:

    WAIT AND SHOW CLOCK : 5 secs
    GO TO : http://www../admirer

    CHOOSE ONE : first guess
    What is your favorite fruit:
    ( ) apple
    ( ) blueberry
    (o) strawberry
    ( ) orange

    CHOOSE ONE : second guess
    What is your favorite location:
    ( ) beach
    (o) picnic
    ( ) Osaka
    ( ) Benton

    CHOOSE ONE : third guess
    What is your favorite book:
    ( ) 1
    (o) 2
    ( ) 3
    ( ) 4

# Another example:

Save stuff to the datastore and use it in the code:

    CHOOSE ONE : fav_fruit
    Which is your favorite fruit?
    ( ) apple
    ( ) orange
    ( ) round
    MERGE : previous answers
    ( ) Write in:
    ONE_LINE_TEXT .

    WHEN SELECTION IS : Write in...
    SHOW TO USER :
    Not my favorite.

    WHEN SELECTION IS : round
    CHOOSE ONE : round_type
    ( ) prune
    ( ) raisin
    ( ) grapes

    ABOUT : fav_fruit

    WHEN SELECTION IS : FIRST
    SHOW TO USER :
    I like apples too!

    WHEN SELECTION IS : orange
    SHOW TO USER :
    I hate oranges. Blah!

    WHEN SELECTION IS : LAST
    SHOW TO USER :
    Cool. I never heard of such fruit.


## Installation

    gem 'moron_text'

