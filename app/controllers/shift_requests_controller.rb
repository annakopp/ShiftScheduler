class ShiftRequestsController < ApplicationController

  def create
    @request= ShiftRequest.new(employee_id: current_user.id,
                               status: "pending",
                               shift_id: params[:shift_id])
    @request.save
    redirect_to shifts_url
  end

  def index
    if current_user.admin?
      @requests = ShiftRequest.where(" status=? AND ? IN (SELECT manager_id FROM users)", "pending", current_user.id).includes(:shift).includes(:employee)
    else
      @requests = current_user.shift_requests.includes(:shift)

      respond_to do |format|
        format.html {render :index}
        format.json {render json: @requests, include: :shift }
      end


    end
  end

  def destroy
    @shift_request = ShiftRequest.find_by_employee_id_and_shift_id(current_user.id, params[:shift_id])
    @shift_request.destroy
    redirect_to shifts_url
  end

  def update
    @shift_request = ShiftRequest.includes(:shift).find(params[:id])
    # @shift = @shift_request.shift
    if @shift_request.update_attributes(status: params[:status])
      @shift.decrement_slots
      # if @shift.slots == @shift.max_slots
#         reqs = @shift.shift_requests.select{|request| request.status=="pending"}
#         reqs.each do |req|
#
#           req.status = "denied"
#         end
#       end
      redirect_to shifts_url
    else
      render[:errors] = @shift_request.errors.full_messages
      redirect_to shifts_url
    end

  end
end
