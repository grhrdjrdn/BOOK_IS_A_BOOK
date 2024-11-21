class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all

    owners = @books.map do |book|
      book.current_owner
    end

    @markers = owners.map do |owner|
      next unless owner.geocoded?

      {
        lat: owner.latitude,
        lng: owner.longitude
      }
    end

    if params[:query].present?
      @books = Book.search_by_title_and_description(params[:query])
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    History.create(date_acquired: Date.today, book: @book, user: current_user)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :authors, :description, :photo)
  end
end
