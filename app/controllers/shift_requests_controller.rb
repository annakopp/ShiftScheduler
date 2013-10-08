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
      @requests = ShiftRequest.where("? IN (SELECT manager_id FROM users)", current_user.id).includes(:shift)
    else
      @requests = current_user.shift_requests
    end
  end

end
