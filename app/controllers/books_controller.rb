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




    # Book.near([current_user.latitude, current_user.longitude], 50, order: :distance).search_by_title_and_description(params[:query])

    if params[:query].present?
      @book_distance_hash = {}
      @books = Book.search_by_title_and_description(params[:query])
      counter = 0
      @books.each do |book|
        @book_distance_hash["book #{counter}"] = { book: book, distance: book.current_owner.distance_to(current_user).round(1)}
        counter += 1
      end
      # raise
    end
  end

  def show
    @request = Request.new

    @requests_on_this_book = Request.joins(:user).where(book: @book, user: current_user)
    authorize @book
    # REQUESTS I MADE ON THIS BOOK
    @requests = @book.requests.where(user: current_user).order("id DESC")
    # REQUESTS I MADE ON THIS BOOK THAT ARE PENDING
    @pending_requests_made = @book.requests.where(user: current_user, status: "pending")
    # INCOMING REQUESTS I HAVE RECEIVED ON THIS BOOK
    @incoming_requests = Request.joins(:history).where(book: @book, "history.user": current_user).order("id DESC")
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
    params.require(:book).permit(:title, :authors, :description, photos: [])
  end
end
