class ShiftsController < ApplicationController

  def new
    @shift = Shift.new(params[:shift])
    render :new
  end

  def create
    params[:shift][:manager_id] = current_user.id
    @shift = Shift.new(params[:shift])
    if @shift.save
      redirect_to users_url
    else
      flash[:errors] = @shift.errors.full_messages
      redirect_to new_shift_url(params)
    end
  end


  def index
    @shifts = current_user.manager.created_shifts
    @shift_requests = current_user.manager.created_shifts.where("id NOT IN (SELECT shift_id FROM shift_requests)")

    # @shift_requests = current_user.manager
 #                .created_shifts
 #                .joins(:shift_requests)
    render :index
  end
  


end
