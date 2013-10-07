class UsersController < ApplicationController
  before_filter :require_current_user!, :only => [:show]
  before_filter :require_no_current_user!, :only => [:create, :new]

  def create
     @user = User.new(params[:user])
     @company = @user.companies.build(params[:company][:company_name])
    begin
      ActiveRecord::Base.transaction do




        @user.save
        @company.save

        raise "invalid" unless @user.valid? && @company.valid?
      end
    rescue
      flash[:errors] =  @user.errors.full_messages
      flash[:errors] << @company.errors.full_messages
      redirect_to new_user_url
    else
      self.current_user = @user
      redirect_to user_url(@user)
    end
  end

  def new
    @user = User.new
  end

  def show
    if params.include?(:id)
      @user = User.find(params[:id])
    else
      redirect_to user_url(current_user)
    end
  end
end
