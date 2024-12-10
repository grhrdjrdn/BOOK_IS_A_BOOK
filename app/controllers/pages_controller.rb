class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  # after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, unless: :skip_pundit?

  def home
  end

  def dashboard

    # The Books I own currently
    latest_histories_subquery = History.select('MAX(id) as id').group(:book_id)
    latest_histories = History.joins(:book).where(id: latest_histories_subquery)
    @my_books = latest_histories.where(user_id: current_user.id)

    # The Books I previously owned
    @my_previously_owned_books = History.where(user_id: current_user.id).where.not(id: @my_books.pluck(:id))

    # all the requests I have made
    @my_requests = Request.where(user_id: current_user.id).order("id DESC")

    # all the requests that I recieved
    @incoming_requests = Request.joins(history: :user).where("history.user_id": current_user.id).order("id DESC")

    @pending_requests = @incoming_requests.select { |request| request.status == "pending" }
  end

end
