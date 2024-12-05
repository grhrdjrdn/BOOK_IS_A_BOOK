class UsersController < ApplicationController
  # GET Users
  def index
    @users = User.all
    @markers = @users.geocoded.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude
      }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])

    # The Books this user currently owns
    latest_histories_subquery = History.select('MAX(id) as id').group(:book_id)
    latest_histories = History.joins(:book).where(id: latest_histories_subquery)
    @books_from_user = latest_histories.where(user_id: @user.id)

    @books = policy_scope(Book)
    owners = @books.map do |book|
      book.current_owner
    end

    @markers = owners.map do |owner|
      next unless owner.geocoded?
      {
        lat: owner.latitude,
        lng: owner.longitude,
        id: owner.id
      }
    end

  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Flat was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

end
