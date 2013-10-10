class ShiftsController < ApplicationController

  # def new
  #   @shift = Shift.new(params[:shift])
  #   render :new
  # end

  def show
    @shift =
        Shift.includes(:shift_requests).includes(:employees).find(params[:id])
    if request.xhr?
      render partial: "shifts/shift"
    else
      render :show
    end
  end

  def create
    parse_date

    @shift = Shift.new(params[:shift])
    if @shift.save

      redirect_to shifts_url
    else
      flash[:errors] = @shift.errors.full_messages
      redirect_to shifts_url
    end
  end


  def index
    @shifts = current_user.manager.created_shifts
    @shift_requests = current_user.manager.created_shifts.where("id NOT IN (SELECT shift_id FROM shift_requests)")

    respond_to do |format|
      format.html {render :index}
      format.json {render json: @shifts }
    end

  end

  private

  def parse_date
    params[:shift][:manager_id] = current_user.id
    new_start = params[:shift][:start_date] + " " + params[:time][:start_time]
    new_end = params[:shift][:end_date] + " " + params[:time][:end_time]
    params[:shift][:start_date] =
                          DateTime.strptime(new_start,'%Y-%m-%d %H:%M')
    params[:shift][:end_date] =
                          DateTime.strptime(new_end, '%Y-%m-%d %H:%M')
  end

end
