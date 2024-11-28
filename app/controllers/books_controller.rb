class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    # @books = Book.all
    @books = policy_scope(Book)
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
    @request = Request.new
    @requests = @book.requests.where(user: current_user)
    @requests_on_this_book = Request.joins(:user).where(book: @book, user: current_user)
    authorize @book
  end

  def new
    @book = Book.new
    authorize @book
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    History.create(date_acquired: Date.today, book: @book, user: current_user)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @book
  end

  def update
    authorize @book
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
