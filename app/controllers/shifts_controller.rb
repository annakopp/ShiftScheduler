class ShiftsController < ApplicationController
  before_filter :require_current_user!

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
    p params
    if can? :manage, current_user
      parse_date

      repeats = params[:times].to_i
      @shifts = []
      begin
        if params[:recurring] == "on"
          repeats.times do
            @shifts << Shift.new(params[:shift])
            params[:shift][:start_date] += params[:repeat_frequency].to_i.days
            params[:shift][:end_date] += params[:repeat_frequency].to_i.days
            p params[:shift]

          end
        else
          @shifts << Shift.new(params[:shift])
        end

        ActiveRecord::Base.transaction do
          @shifts.each{|shift| shift.save}
          raise "error" if !@shifts.all?{|shift| shift.valid?}
        end
      rescue
        respond_to do |format|
          format.html do 
            flash[:errors] = ["ahh"]
            redirect_to shifts_url
          end
          format.json {render status: 422}
        end
      else
        redirect_to shifts_url
      end
    else
      redirect_to shifts_url
    end
  end


  def index
    @shifts = current_user.manager.created_shifts.includes(:shift_requests).includes(:employees)
    @js_abilities = (ability_to_array(current_ability))
    @current_user = current_user
    @shifts.each do|shift|
      shift.requested = shift.request_status(@current_user)
      shift.can_request = shift.can_be_requested_by?(@current_user)
      shift.can_cancel = shift.can_be_cancelled_by?(@current_user)
    end
    respond_to do |format|
      format.html {render :index}
      format.json {render json: @shifts }
    end

  end


  def destroy
    if cannot? :destroy, current_user
      redirect_to shifts_url
    else
      @shift = Shift.find(params[:id])
      @shift.destroy
      redirect_to shifts_url
    end
  end

  private

  def parse_date
    params[:shift][:manager_id] = current_user.id
    new_start = params[:shift][:start_date] + " " + params[:time][:start_time]
    new_end = params[:shift][:end_date] + " " + params[:time][:end_time]
    params[:shift][:start_date] =
                          DateTime.strptime(new_start,'%Y/%m/%d %H:%M')
    params[:shift][:end_date] =
                          DateTime.strptime(new_end, '%Y/%m/%d %H:%M')
  end

end
