class ShiftsController < ApplicationController

  def new
    @shift = Shift.new(params[:shift])
    render :new
  end

  def create
    params[:shift][:manager_id] = current_user.id
    new_start = params[:shift][:start_date] + " " + params[:time][:start_time]
    new_end = params[:shift][:end_date] + " " + params[:time][:end_time]
    params[:shift][:start_date] =
                          DateTime.strptime(new_start,'%Y-%m-%d %H:%M')
    params[:shift][:end_date] =
                          DateTime.strptime(new_end, '%Y-%m-%d %H:%M')

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
      # format.json {render json: @shifts.to_json(only: [:end_date, :start_date, :name, :slots])}
      format.json {render json: @shifts }
    end

  end



end
