class ShiftRequestsController < ApplicationController

  def create
    @request= ShiftRequest.new(employee_id: current_user.id,
                               status: "pending",
                               shift_id: params[:shift_id])
    @request.save
    redirect_to shifts_url
  end

  def index
      @requests = ShiftRequest.find_by_shift_id(params[:shift_id])
      respond_to do |format|
        format.html {render :index}
        format.json {render json: @requests }
      end
  end

  def destroy
    @shift_request = ShiftRequest.find_by_employee_id_and_shift_id(current_user.id, params[:shift_id])
    @shift_request.destroy
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @shift_request }
    end
  end

  def update
    @shift_request = ShiftRequest.includes(:shift).find(params[:id])
    @shift = @shift_request.shift
    if @shift_request.update_attributes(status: params[:status])
      @shift.count_slots
      if @shift.slots == @shift.max_slots
        reqs = @shift.shift_requests.select{|request| request.status=="pending"}
        reqs.each do |req|

          req.status = "denied"
          req.save
        end
      end
      render json: @shift_request
    else
      render[:errors] = @shift_request.errors.full_messages
      redirect_to shifts_url
    end

  end
end
