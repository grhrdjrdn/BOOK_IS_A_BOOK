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


# more books
more_books = [
  {
    author: "Voltaire",
    title: "Candide",
    description: "A satirical novella that follows the optimistic young Candide as he experiences the hardships of the world, challenging his belief in philosophical optimism.",
    image_link: "https://images.randomhouse.com/cover/9780143039426"
  },
  {
    author: "D. H. Lawrence",
    title: "Lady Chatterley’s Lover",
    description: "A controversial novel exploring the physical and emotional relationship between a married woman and her gamekeeper, delving into themes of class and sexuality.",
    image_link: "https://images.randomhouse.com/cover/9780143039617"
  },
  {
    author: "Peter Matthiessen",
    title: "The Snow Leopard",
    description: "A travel memoir recounting the author’s journey through the Himalayas in search of the elusive snow leopard, offering profound insights into nature and self-discovery.",
    image_link: "https://images.randomhouse.com/cover/9780143105510"
  },
  {
    author: "Jack Kerouac",
    title: "On the Road: The Original Scroll",
    description: "The unedited, original version of Kerouac’s classic novel, capturing the raw energy and spirit of his cross-country adventures.",
    image_link: "https://images.randomhouse.com/cover/9780143105466"
  },
  {
    author: "Franz Kafka",
    title: "Metamorphosis and Other Stories",
    description: "A collection of Kafka’s most famous works, including 'The Metamorphosis,' exploring themes of alienation and existential anxiety.",
    image_link: "https://images.randomhouse.com/cover/9780143105244"
  },
  {
    author: "Sei Shonagon",
    title: "The Pillow Book",
    description: "A collection of essays, lists, and anecdotes by a 10th-century Japanese court lady, offering a vivid glimpse into court life during the Heian period.",
    image_link: "https://images.randomhouse.com/cover/9780140448061"
  },
  {
    author: "Rachel L. Carson",
    title: "Under the Sea-Wind",
    description: "A poetic and detailed exploration of marine life, showcasing Carson's deep understanding and love for the natural world.",
    image_link: "https://images.randomhouse.com/cover/9780143104964"
  },
  {
    author: "Leslie Marmon Silko",
    title: "Ceremony",
    description: "A novel about a Native American World War II veteran's struggle to reconcile his cultural heritage with the modern world.",
    image_link: "https://images.randomhouse.com/cover/9780143104919"
  },
  {
    author: "Shirley Jackson",
    title: "The Haunting of Hill House",
    description: "A classic horror novel about four seekers who arrive at a notoriously unfriendly mansion called Hill House.",
    image_link: "https://images.randomhouse.com/cover/9780143039983"
  },
  {
    author: "Homer",
    title: "The Odyssey",
    description: "An epic poem recounting the adventures of Odysseus as he journeys home after the Trojan War.",
    image_link: "https://images.randomhouse.com/cover/9780143039952"
  },
  {
    author: "Thomas Pynchon",
    title: "Gravity’s Rainbow",
    description: "A complex novel set during World War II, weaving together numerous characters and plots in a rich tapestry of themes.",
    image_link: "https://images.randomhouse.com/cover/9780143039945"
  },
  {
    author: "Reginald Rose",
    title: "Twelve Angry Men",
    description: "A play that examines the deliberations of a jury in a homicide trial, exploring themes of justice and prejudice.",
    image_link: "https://images.randomhouse.com/cover/9780143104407"
  },
  {
    author: "Leo Tolstoy",
    title: "The Death of Ivan Ilyich and Other Stories",
    description: "A collection of short stories exploring themes of mortality, faith, and the search for meaning.",
    image_link: "https://images.randomhouse.com/cover/9780140449617"
  },
  {
    author: "Natsume Soseki",
    title: "Kokoro",
    description: "A novel exploring the transition from traditional Japanese society to the modern era, focusing on the relationship between a young man and his mentor.",
    image_link: "https://images.randomhouse.com/cover/9780143106036"
  },
  {
    author: "Émile Zola",
    title: "Thérèse Raquin",
    description: "A novel about a young woman trapped in a loveless marriage who embarks on a passionate affair, leading to tragic consequences.",
    image_link: "https://images.randomhouse.com/cover/9780140449440"
  },
  {
    author: "Jorge Luis Borges",
    title: "The Aleph and Other Stories",
    description: "A collection of short stories blending reality and fantasy, showcasing Borges' literary genius.",
    image_link: "https://images.randomhouse.com/cover/9780142437889"
  },
  {
    author: "Leo Tolstoy",
    title: "Anna Karenina",
    description: "A novel chronicling the tragic love affair between Anna Karenina and Count Vronsky, set against the backdrop of Russian society.",
    image_link: "https://images.randomhouse.com/cover/9780143035008"
  },
  {
    author: "Younghill Kang",
    title: "East Goes West",
    description: "A semi-autobiographical novel about a young Korean man's experiences in America during the early 20th century.",
    image_link: "https://images.randomhouse.com/cover/9780143134305"
  },
  {
    author: "Homer",
    title: "The Iliad",
    description: "An epic poem recounting the events of the Trojan War, focusing on the hero Achilles and his struggles with anger and fate.",
    image_link: "https://images.randomhouse.com/cover/9780140445923"
  },
  {
    author: "George Orwell",
    title: "1984",
    description: "A dystopian novel exploring themes of surveillance, totalitarianism, and individual freedom under a repressive regime.",
    image_link: "https://images.randomhouse.com/cover/9780451524935"
  },
  {
    author: "Mary Shelley",
    title: "Frankenstein",
    description: "A Gothic novel about Victor Frankenstein, a scientist who creates a sentient creature, and the consequences of his actions.",
    image_link: "https://images.randomhouse.com/cover/9780141439471"
  },
  {
    author: "Fyodor Dostoevsky",
    title: "Crime and Punishment",
    description: "A psychological exploration of morality, guilt, and redemption through the story of Raskolnikov, a man who commits murder.",
    image_link: "https://images.randomhouse.com/cover/9780143107637"
  },
  {
    author: "Virginia Woolf",
    title: "To the Lighthouse",
    description: "A stream-of-consciousness novel focusing on the Ramsay family and their visits to the Isle of Skye over a decade.",
    image_link: "https://images.randomhouse.com/cover/9780156907392"
  },
  {
    author: "Toni Morrison",
    title: "Beloved",
    description: "A Pulitzer Prize-winning novel about Sethe, an escaped slave haunted by the memory of her past and the ghost of her daughter.",
    image_link: "https://images.randomhouse.com/cover/9781400033416"
  },
  {
    author: "Gabriel García Márquez",
    title: "One Hundred Years of Solitude",
    description: "A landmark novel in magical realism, chronicling the rise and fall of the Buendía family in the fictional town of Macondo.",
    image_link: "https://images.randomhouse.com/cover/9780060883287"
  },
  {
    author: "Harper Lee",
    title: "To Kill a Mockingbird",
    description: "A Pulitzer Prize-winning novel that addresses themes of racial injustice and moral growth in the Deep South.",
    image_link: "https://images.randomhouse.com/cover/9780061120084"
  },
  {
    author: "Albert Camus",
    title: "The Stranger",
    description: "A novel about an emotionally detached man who commits murder, exploring themes of existentialism and absurdity.",
    image_link: "https://images.randomhouse.com/cover/9780679720201"
  }
]

more_books.each do |book|
  attributes = { title: book[:title], authors: book[:author], description: book[:description] }
  file = URI.parse(book[:image_link]).open
  book = Book.new(attributes)
  book.photos.attach(io: file, filename: "#{book[:title]}.jpeg", content_type: "image/jpeg")
  book.save
  puts "created #{book.title} by #{book.authors}"
end












url = "http://books.toscrape.com/catalogue/page-1.html"
# 1. We get the HTML page content
html_content = URI.open(url).read
# 2. We build a Nokogiri document from this file
doc = Nokogiri::HTML.parse(html_content)

books = doc.search(".product_pod")

books.each do |book|
  # book title
  title = book.search("h3 a")[0]["title"]
  # img_src = book.search(".image_container a img")[0]["src"]
  # img_link = img_src.gsub("..", "http://books.toscrape.com/")

  # book description and image link
  book_ref = book.search(".image_container a")[0]["href"]
  book_url = "http://books.toscrape.com/catalogue/#{book_ref}"
  html_content = URI.open(book_url).read
  doc = Nokogiri::HTML.parse(html_content)
  book_description = doc.search(".product_page p")[3].text.sub(/...more/, '').strip
  img_src = doc.search(".item.active img")[0]["src"]
  img_link = img_src.gsub("../../", "http://books.toscrape.com/")

  # authors
  response = RestClient.get "https://openlibrary.org/search.json?title=#{title}"
  repos = JSON.parse(response)
  if repos["docs"].empty? != true
    authors = repos["docs"][0]["author_name"].join(", ")

    # create 16 books and seed images
    attributes = { title: title, authors: authors, description: book_description }
    file = URI.parse(img_link).open
    book = Book.new(attributes)
    book.photos.attach(io: file, filename: "#{title}.png", content_type: "image/png")
    book.save
    puts "created #{book.title} by #{book.authors}"
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
