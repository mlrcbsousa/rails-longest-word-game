require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if !valid_attempt?(@word, @letters.split(' '))
      @score = 1
    elsif !attempt_exists?(@word)
      @score = 2
    else
      @score = 3
    end
  end

  private

  def valid_attempt?(word, letters)
    word.upcase.chars.each do |char|
      ind = letters.index(char)
      ind.nil? ? (return false) : letters.delete_at(ind)
    end
  end

  def attempt_exists?(word)
    url = 'https://wagon-dictionary.herokuapp.com/' + word
    json_response = JSON.parse(open(url).read)
    json_response["found"]
  end
end