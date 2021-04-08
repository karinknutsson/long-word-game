require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def create_letters(alphabet)
    letters = []
    10.times do
      letters.push(alphabet.sample)
    end
    create_letters(alphabet) if letters.select { |l| l =~ /[aeiou]/ }.length.positive?
    letters
  end

  def new
    alphabet = ('A'..'Z').to_a
    @letters = create_letters(alphabet)
  end

  def match?(solution, letters)
    solution.each do |char|
      return false unless letters.include?(char)

      letters.delete_at(letters.index(char))
    end
    true
  end

  def in_dictionary?(word)
    return false if word.length == 1 && word != 'a'

    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_s = URI.open(url).read
    response_h = JSON.parse(response_s)
    return true if response_h['found'] == true

    false
  end

  def score
    letters = params[:letters].split(' ')
    solution = params[:solution].upcase.split('')
    match = match?(solution, letters)
    real_word = in_dictionary?(solution.join.downcase)
    @result = { letters: letters, solution: solution }
    return @result[:score] = 2 if match && real_word
    return @result[:score] = 1 if match

    @result[:score] = 0
  end
end
