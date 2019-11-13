require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
  end

  def score
    @attempt = params['word']
    @grid = params['grid']
    @message = 'Good job! Your score is:'
    @valid = true
    @score = params['word'].length
    unless english?(@attempt)
      @message = "Not an english word."
      @valid = false
    end
    unless valid?(@attempt, @grid) # doesnt work for KILL when only KIL present
      @message = "Not a valid word."
      @valid = false
    end
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    alphabet_array = ('A'..'Z').to_a
    grid_array = Array.new(grid_size)
    grid_array.map! { alphabet_array[rand(0..25)] }
    grid_array
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    url_text = open(url).read
    dictionary_hash = JSON.parse(url_text)
    dictionary_hash['found']
  end

  def valid?(attempt, grid)
    attempt_array = attempt.upcase.split('')
    attempt_array.each do |letter|
      grid.include?(letter)
      if grid.include?(letter)
        grid.delete(letter)
      else
        return false
      end
    end
    true
  end

end
