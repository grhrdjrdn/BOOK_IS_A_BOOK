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
  book_description = doc.search(".product_page p")[3].text.sub(/...more/, '').strip

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
  { email: "user1@mail.com", username: "melanie123", nickname: "Melanie", password: "123456", location: "225 Mitchell St, Northcote, VIC, 3070, Australia" },
  { email: "user2@mail.com", username: "luca1992", nickname: "Luca", password: "123456", location: "15 Smith St, Collingwood, VIC, 3066, Australia" },
  { email: "user3@mail.com", username: "zara789", nickname: "Zara", password: "123456", location: "78 Lygon St, Carlton, VIC, 3053, Australia" },
  { email: "user4@mail.com", username: "noah2023", nickname: "Noah", password: "123456", location: "32 Gertrude St, Fitzroy, VIC, 3065, Australia" },
  { email: "user5@mail.com", username: "emma_bella", nickname: "Emma", password: "123456", location: "10 Bourke St, Melbourne, VIC, 3000, Australia" },
  { email: "user6@mail.com", username: "oliver777", nickname: "Oliver", password: "123456", location: "50 Queens Rd, Melbourne, VIC, 3004, Australia" },
  { email: "user7@mail.com", username: "sophia2022", nickname: "Sophia", password: "123456", location: "88 Acland St, St Kilda, VIC, 3182, Australia" },
  { email: "user8@mail.com", username: "william001", nickname: "William", password: "123456", location: "40 Chapel St, Windsor, VIC, 3181, Australia" },
  { email: "user9@mail.com", username: "mia_xoxo", nickname: "Mia", password: "123456", location: "12 Flinders Lane, Melbourne, VIC, 3000, Australia" },
  { email: "user10@mail.com", username: "james_king", nickname: "James", password: "123456", location: "99 Bridge Rd, Richmond, VIC, 3121, Australia" }
];

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
