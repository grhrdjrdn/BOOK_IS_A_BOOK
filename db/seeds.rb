# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "nokogiri"
require "json"
require "rest-client"

Book.destroy_all

url = "http://books.toscrape.com/catalogue/page-1.html"
# 1. We get the HTML page content
html_content = URI.open(url).read
# 2. We build a Nokogiri document from this file
doc = Nokogiri::HTML.parse(html_content)

books = doc.search(".product_pod")

books.each do |book|
  # book title and image link
  title = book.search("h3 a")[0]["title"]
  img_src = book.search(".image_container a img")[0]["src"]
  img_link = img_src.gsub("..", "http://books.toscrape.com/")

  # book description
  book_ref = book.search(".image_container a")[0]["href"]
  book_url = "http://books.toscrape.com/catalogue/#{book_ref}"
  html_content = URI.open(book_url).read
  doc = Nokogiri::HTML.parse(html_content)
  book_description = doc.search(".product_page p")[3].text.strip

  # authors
  response = RestClient.get "https://openlibrary.org/search.json?title=#{title}"
  repos = JSON.parse(response)
  if repos["docs"].empty? != true
    authors = repos["docs"][0]["author_name"].join(", ")

    # create 16 books and seed images
    attributes = { title: title, authors: authors, description: book_description }
    file = URI.parse("#{img_link}").open
    book = Book.new(attributes)
    book.photo.attach(io: file, filename: "#{title}.png", content_type: "image/png")
    book.save
  end

end

# create users
User.destroy_all
users = [
  { email: "user1@mail.com", username: "melanie123", nickname: "Mel", password: "123456", location: "225 Mitchell St, Northcote, VIC, 3070, Australia"},
  { email: "user2@mail.com", username: "luca1992", nickname: "Luc", password: "123456" },
  { email: "user3@mail.com", username: "zara789", nickname: "Zee", password: "123456" },
  { email: "user4@mail.com", username: "noah2023", nickname: "Noe", password: "123456" },
  { email: "user5@mail.com", username: "emma_bella", nickname: "Emm", password: "123456" },
  { email: "user6@mail.com", username: "oliver777", nickname: "Oll", password: "123456" },
  { email: "user7@mail.com", username: "sophia2022", nickname: "Soi", password: "123456" },
  { email: "user8@mail.com", username: "william001", nickname: "Wil", password: "123456" },
  { email: "user9@mail.com", username: "mia_xoxo", nickname: "Mia", password: "123456" },
  { email: "user10@mail.com", username: "james_king", nickname: "Jim", password: "123456" }
]

users.each do |attributes|
  user = User.create!(attributes)
  puts "Created #{user.email}, #{user.username}, #{user.nickname} with password #{user.password}"
end

# create a history for each book
Book.all.each_with_index do |book, index|
  attributes = {
    book: book,
    user: User.all[index%User.all.size],
    date_acquired: DateTime.now
  }
  history = History.create!(attributes)
  puts "#{history.user.nickname} owns #{history.book.title}"
end
