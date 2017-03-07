# This file provides items for rover.rb.
#
# Rover will `require` this file and then call `items`, which must
# return an array of hashes. Each hash in the array must contain two
# keys: `:source`, which specifies the source file, and `:target`
# which specifies the target.
#
# This file is in Ruby -- rather than YAML or JSON -- to enable easy
# extensibility. The `items` function can execute any Ruby code
# before returning its array.

def items
  return [
    {
      :source => "~/Dropbox/Airtype/dotfiles/emacs/.emacs.d",
      :target => "~/emacs.d"
    },
    {
      :source => "~/Dropbox/Airtype/dotfiles/emacs/.emacs",
      :target => "~/emacs"
    },
    {
      :source => "~/Dropbox/Airtype/todo.org",
      :target => "~/todo.org"
    }
  ]
end
