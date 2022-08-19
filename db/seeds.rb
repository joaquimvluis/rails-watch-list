# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'
require 'open-uri'

url = "https://tmdb.lewagon.com/movie/top_rated"
data_serialized = URI.open(url).read
data = JSON.parse(data_serialized)

puts 'Cleaning records'
Movie.destroy_all

puts 'Creating Lists'
lists = []
rand(5..10).times do
  lists << List.create!(name: Faker::Emotion.unique.noun)
end

puts 'Creating movies'
img_url = 'https://image.tmdb.org/t/p/w200'
movies = []
20.times do |index|
  result = data["results"][index]
  movies << Movie.create!(title: result["title"], overview: result["overview"], poster_url: img_url + result["poster_path"], rating: result["vote_average"] )
end

puts 'Creating bookmarks'
lists.each do |list|
  rand(5..10).times do
    movie = movies.sample
    Bookmark.create!(comment: Faker::Quote.yoda, movie_id: movie.id, list_id: list.id) unless movie.nil?
    movies.empty? ? break : movies.delete(movie)
  end
end

# Faker::Quote.yoda
# Faker::Creature::Animal.name:
# db/seeds.rb
puts 'Finished'
