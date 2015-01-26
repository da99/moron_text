
# Note:

This is not ready yet.

# Installation

    gem 'moron_text'

# Moron\_Text

## Example: Menu

```ruby
  moron = Moron_Text.new(<<-EOF)
    CORRECT /*
    This is the right answer.
    WRONG /*
    This is the 1st wrong answer.
    WRONG /*
    This is the 2nd wrong answer.
    WRONG /*
    This is the 3rd wrong answer.
    ON /* CORRECT
    You chose wisely.
  EOF

  moron.run do | name, line, text |
    case name
    when 'CORRECT'
    when 'WRONG'
    when 'ON'
    else
      text.next
    end
  end
```

