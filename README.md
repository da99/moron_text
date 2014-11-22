
# Note:

This is not ready yet.

# Moron_Text

Takes a string and run it as an app:

    MENU: first_guess
    What is your favorite fruit:
    o: apple
    o: blueberry
    x: strawberry
    o: orange

    ON: right answer
    MENU: second_guess
    What is your favorite location:
    o: beach
    x: picnic
    o: Osaka
    o: Benton


    ON: right answer
    MENU: third_guess
    What is your favorite book:
    o: 1
    x: 2
    o: 3
    o: 4

    ON: any wrong answer
    Show picture: http://www..../failure.jpg

    ON: final right answer
    You got it! Wait while I show you your secret
    admirer.
    Wait and show clock: 5 seconds
    Go to: http://www../admirer

# Another example:

Save stuff to the datastore and use it in the code:

    Choose One: fav_fruit
    Which is your favorite fruit?
    o: "apple"
    o: "orange"
    o: round
    merge: previous answers.
    o: "Write in:" one_line_text

    When selection is none of the below:
    Show this to user:
    Not my favorite.

    When selection is: round
    Choose One: round_type
    o: prune
    o: raisin
    o: grapes

    When selection is none of the above:
      Enforce choice.

    Back to: fav_fruit

    When selection is: first
    Show this to user:
    I like apples too!

    When selection is: Orange
    Show this to user:
    I hate oranges. Blah!

    When selection is: last
    Show this to user:
    Cool. I never heard of such fruit.


## Installation

    gem 'moron_text'

