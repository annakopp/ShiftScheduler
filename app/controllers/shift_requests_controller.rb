class ShiftRequestsController < ApplicationController

  def create
    begin
      @requests= []
      ActiveRecord::Base.transaction do

        params[:shift_requests].each do |request|
          @requests << ShiftRequest.new(shift_id: request.to_i,
                                        employee_id: current_user.id,
                                        status: "pending")
        end

        @requests.each do |request|
          request.save
        end

        raise "error" if @requests.any?{|request| !request.valid?}
      end
    rescue
      flash[:errors] = ["Ahh"]
      redirect_to shifts_url
    else
      redirect_to users_url
    end
  end

  def index
    if current_user.admin?
      @requests = ShiftRequest.where(" status=? AND ? IN (SELECT manager_id FROM users)", "pending", current_user.id).includes(:shift).includes(:employee)
    else
      @requests = current_user.shift_requests.includes(:shift)
      #@shifts = @requests.map{|req| req.shift }

      respond_to do |format|
        format.html {render :index}
        # format.json {render json: @shifts.to_json(only: [:end_date, :start_date, :name, :slots])}
        format.json {render json: @requests, include: :shift }
      end


    end
  end

  def destroy
    @shift_request = ShiftRequest.find(params[:id])
    @shift_request.destroy
    redirect_to shift_requests_url
  end

  def update
    @shift_request = ShiftRequest.find(params[:id])
    if @shift_request.update_attributes(status: params[:status])
      @shift_request.shift.decrement_slots
      redirect_to shift_requests_url
    else
      render[:errors] = @shift_request.errors.full_messages
      redirect_to shift_requests_url
    end

  end
end
