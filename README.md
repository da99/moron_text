
# Note:

This is not ready yet.

# Moron_Text

Takes a string and run it as an app:

    Choose One: fav_fruit

    Which is your favorite fruit?

    o: Apple.
    o: Orange.
    merge: previous answers.
    o: Other.

    When selection is none of the below:

      #
        Show this to user:

        Not my favorite.
      #!

    When selection is: first

      #
        Show this to user:

          I like apples too!
      #!

    When selection is: Orange

      #
      Show this to user:

        I hate oranges. Blah!
      #!

    When selection is: last

      #
      Get text from user and save as: fav_fruit.

      Show this to user:

        Cool. I never heard of such fruit.
      #!

## Installation

    gem 'moron_text'

