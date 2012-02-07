#!/usr/bin/env ruby -i
#A Markov Chain generator.

require_relative 'marky_markov/persistent_dictionary'
require_relative 'marky_markov/two_word_sentence_generator'

module MarkyMarkov
  VERSION = '0.1.0'

  class TemporaryDictionary
    # Create a new Temporary Markov Chain Dictionary and sentence generator for use.
    # @example Create a new Temporary Dictionary.
    #   markov = MarkyMarkov::TemporaryDictionary.new
    # @return [Object] a MarkyMarkov::TemporaryDictionary object.
    def initialize
      @dictionary = TwoWordDictionary.new
      @sentence = TwoWordSentenceGenerator.new(@dictionary)
    end
    # Parses a given file and adds the sentences it contains to the current dictionary.
    #
    # @example Open a text file and add its contents to the dictionary.
    #   markov.parse_file "text.txt"
    # @param [File] location the file you want to add to the dictionary.
    def parse_file(location)
      @dictionary.parse_source(location, true)
    end
    # Parses a given string and adds them to the current dictionary.
    #
    # @example Add a string to the dictionary.
    #   markov.parse_string "I could really go for some Chicken Makhani."
    # @param [String] sentence the sentence you want to add to the dictionary.
    def parse_string(string)
      @dictionary.parse_source(string, false)
    end
    # Generates a sentence/sentences of n words using the dictionary generated via
    # parse_string or parse_file.
    #
    # @example Generate a 40 word long string of words.
    #   markov.generate_n_words(40)
    # @param [Int] wordcount the number of words you want generated.
    # @return [String] the sentence generated by the dictionary.
    def generate_n_words(wordcount)
      @sentence.generate(wordcount)
    end
    # Clears the temporary dictionary's hash, useful for keeping
    # the same dictionary object but removing the words it has learned.
    #
    # @example Clear the Dictionary hash.
    #   markov.clear!
    def clear!
      @dictionary.dictionary.clear
    end
  end

  class Dictionary < TemporaryDictionary
    # Open (or create if it doesn't exist) a Persistent Markov Chain Dictionary
    # and sentence generator for use.
    #
    # @example Create a new Persistent Dictionary object.
    #   markov = MarkyMarkov::Dictionary.new("#{ENV["HOME"]}/markov_dictionary")
    def initialize(location)
      @dictionary = PersistentDictionary.new(location)
      @sentence = TwoWordSentenceGenerator.new(@dictionary)
    end
    # Save the Persistent Dictionary file into JSON format for later use.
    #
    # @example Save the dictionary to disk.
    #   markov.save_dictionary!
    def save_dictionary!
      @dictionary.save_dictionary!
    end
    # Class Method: Takes a dictionary location/name and deletes it from the file-system.
    #
    # @note To ensure that someone doesn't pass in something that shouldn't be deleted by accident,
    #   the filetype .mmd is added to the end of the supplied arguement, so do not include the
    #   extension when calling the method.
    #
    # @example Delete the dictionary located at '~/markov_dictionary.mmd'
    #   MarkyMarkov::Dictionary.delete_dictionary!("#{ENV["HOME"]}/markov_dictionary")
    # @param [String] location location/name of the dictionary file to be deleted.
    def self.delete_dictionary!(location)
      PersistentDictionary.delete_dictionary!(location)
    end
  end
end
