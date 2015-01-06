
require 'Bacon_Colored'
require 'moron_text'
require 'pry'

def trim str
  str.split("\n").map(&:strip).join("\n")
end
