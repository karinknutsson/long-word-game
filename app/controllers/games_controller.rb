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

  def compute_score(letters)
    score = 0
    letters.each do |l|
      score += 1 if l.scan(/[AEILNORSTU]/i).length.positive?
      score += 2 if l.scan(/[DG]/i).length.positive?
      score += 3 if l.scan(/[BCMP]/i).length.positive?
      score += 4 if l.scan(/[FHVWY]/i).length.positive?
      score += 5 if l.scan(/K/i).length.positive?
      score += 8 if l.scan(/[JX]/i).length.positive?
      score += 10 if l.scan(/[QZ]/i).length.positive?
    end
    score
  end

  def score
    letters = params[:letters].split(' ')
    solution = params[:solution].upcase.split('')
    match = match?(solution, letters)
    real_word = in_dictionary?(solution.join.downcase)
    @result = { letters: letters, solution: solution }
    return @result[:score] = compute_score(letters) if match && real_word
    return @result[:score] = -1 if match

    @result[:score] = -2
  end
end
