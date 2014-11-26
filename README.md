
# Note:

This is not ready yet.

# Moron_Text

Takes a string and run it as an app:

    On :: any wrong answer
    Show picture :: http://www..../failure.jpg

    On :: final right answer

    You got it! Wait while I show you your secret
    admirer.

    Please wait a few seconds:

    Wait and show clock :: 5 secs
    Go to :: http://www../admirer

    Menu :: first guess
    What is your favorite fruit:
    ( ) apple
    ( ) blueberry
    (x) strawberry
    ( ) orange

    Menu :: second guess
    What is your favorite location:
    ( ) beach
    (x) picnic
    ( ) Osaka
    ( ) Benton

    Menu :: third guess
    What is your favorite book:
    ( ) 1
    (x) 2
    ( ) 3
    ( ) 4

# Another example:

Save stuff to the datastore and use it in the code:

    (-) Choose One fav_fruit
    Which is your favorite fruit?
    ( ) apple
    ( ) orange
    ( ) round
    (-) merge previous answers.
    ( ) "Write in:" one_line_text

    (-) When selection is none of the below
    (-) Show this to user
    Not my favorite.

    (-) When selection is round
    Choose One (-) round_type
    () prune
    () raisin
    () grapes

    (-) When selection is none of the above
      Enforce choice.

    (-) Back to fav_fruit

    (-) When selection is first
    (-) Show to user
    I like apples too!

    (-) When selection is Orange
    (-) Show this to user
    I hate oranges. Blah!

    (-) When selection is last
    (-) Show to user
    Cool. I never heard of such fruit.


## Installation

    gem 'moron_text'

