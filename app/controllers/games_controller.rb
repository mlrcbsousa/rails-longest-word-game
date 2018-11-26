require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if !valid_attempt?(@word, @letters.split(' '))
      @result = 1
    elsif !attempt_exists?(@word)
      @result = 2
    else
      if session[:score].nil?
        session[:score] = @word.length
      end
      session[:score] += @word.length
      @score = session[:score]
      @result = 3
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
    # hash.with_indifferent_access
    json_response = JSON.parse(open(url).read, symbolize_names: true)
    json_response[:found]
  end
end
