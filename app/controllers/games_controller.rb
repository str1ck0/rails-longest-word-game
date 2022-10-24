require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 7.times.map { ('a'..'z').to_a.sample }
    @letters += 3.times.map { %w[a e i o u y].sample }
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").downcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
