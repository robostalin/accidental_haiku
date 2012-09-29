class AccidentalHaiku
  include Cinch::Plugin

  match /count (.*)/

  def initialize(*args)
    @total_syllables = 0
    super
  end

  def execute(message, string)
    syllable_count = count_syllables(string)
    @total_syllables += syllable_count
    message.reply "#{syllable_count} more syllables for a total of #{@total_syllables} syllables."
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
