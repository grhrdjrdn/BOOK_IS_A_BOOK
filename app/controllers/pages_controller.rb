class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    # the flats that I have uploaded
    # @my_books = Book.where(user_id: current_user.id)
    # # all the bookings I have made
    # @my_bookings = Booking.where(user_id: current_user.id)
    # # the flat id's of the bookings that I have made
    # flat_ids = Booking.where(user_id: current_user.id).pluck(:flat_id)
    # # the flat models of the bookings I have made
    # @my_bookings_flats = Flat.where(id: flat_ids)
    # # the flat id's of the flats I have uploaded
    # my_flat_ids = @my_flats.pluck(:id)
    # # any bookings other people have made on my flats
    # @bookings_made_to_me = Booking.where(flat_id: my_flat_ids)

    # The Books I own currently (with help from chatgpt – what is going on here?)
    latest_histories_subquery = History.select('MAX(id) as id').group(:book_id)
    latest_histories = History.joins(:book).where(id: latest_histories_subquery)
    @my_books = latest_histories.where(user_id: current_user.id)

  end

end
