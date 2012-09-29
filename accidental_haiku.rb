class AccidentalHaiku
  include Cinch::Plugin

  listen_to :message

  def initialize(*args)
    super

    @haiku_target          = [5,7,5]
    @current_haiku_counts  = []
    @current_haiku_strings = []
  end

  def listen(event)
    @current_haiku_strings.push(event.message)
    @current_haiku_strings.shift if @current_haiku_strings.length > 3

    @current_haiku_counts.push(count_syllables(event.message))
    @current_haiku_counts.shift if @current_haiku_counts.length > 3

    event.reply "Haiku detected!" if @current_haiku_counts == @haiku_target
  end

protected

  def count_syllables(string)
    # Original written by Elisabeth Hendrickson, Quality Tree Software, Inc.
    # Copyright (c) 2009 Quality Tree Software, Inc.
    #
    # Edits by Elliot Crosby-McCullough
    #
    # This work is licensed under the
    # Creative Commons Attribution 3.0 United States License.
    #
    # To view a copy of this license, visit
    #      http://creativecommons.org/licenses/by/3.0/us/
    consonants = "bcdfghjklmnpqrstvwxz"
    vowels = "aeiouy"
    processed = string.downcase
    suffix_bonus = 0

    if processed.match(/ly$/)
      suffix_bonus = 1
      processed.gsub!(/ly$/, "")
    end

    if processed.match(/[a-z]ed$/)
      # Not counting "ed" as an extra symbol.
      # So 'blessed' is assumed to be said as 'blest'
      suffix_bonus = 0
      processed.gsub!(/ed$/, "")
    end

    processed.gsub!(/iou|eau|ai|au|ay|ea|ee|ei|oa|oi|oo|ou|ui|oy/, "@") #vowel combos
    processed.gsub!(/qu|ng|ch|rt|[#{consonants}h]/, "=") #consonant combos
    processed.gsub!(/[#{vowels}@][#{consonants}=]e$/, "@|") # remove silent e
    processed.gsub!(/[#{vowels}]/, "@") #all remaining vowels will be counted

    return processed.count("@") + suffix_bonus
  end

end
