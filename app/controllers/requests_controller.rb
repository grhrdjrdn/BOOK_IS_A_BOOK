class RequestsController < ApplicationController


  def create
    @request = Request.new
    @book = Book.find(params[:book_id])
    @request.book = @book
    @request.user = current_user
    @history = @book.histories.last
    @request.history = @history
    if @request.save
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @request = Request.find(params[:id])
    @message = Message.new
  end

  def new
    @request = Request.new
    @book = Book.find(params[:book_id])
  end

  def approve
    @request = Request.find(params[:request_id])
    @request.status = 1
    @history = History.new
    @history.user = @request.user
    @history.book = @request.book
    @history.date_acquired = DateTime.now
    @history.save
    respond_to do |format|
      if @request.save
        format.html { redirect_to dashboard_path }
        format.json { render json: {status: "swapped"} }
      end
    end
  end

  def deny
    @request = Request.find(params[:request_id])
    @request.status = 2
    respond_to do |format|
      if @request.save
        format.html { redirect_to dashboard_path }
        format.json { render json: {status: "denied"} }
      end
    end
  end

  private

  # def request_params
  #   params.require(:request).permit()
  # end

end
