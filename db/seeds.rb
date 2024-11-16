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
