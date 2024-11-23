class RequestsController < ApplicationController

  def create
    @request = Request.new
    @book = Book.find(params[:book_id])
    @request.book = @book
    @request.user = current_user
    if @request.save
      redirect_to @book
    else
      render "books/show"
    end
  end

  def show
    @request = Request.find(params[:id])
    @message = Message.new
  end
end
