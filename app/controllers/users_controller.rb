class UsersController < ApplicationController
  before_filter :require_admin, only: [:add_employee, :create_employee, :list_employees]
  before_filter :require_current_user!, except: [:new, :create, :confirm_user, :update_confirmed]
  before_filter :require_no_current_user!, :only => [:create, :new]


  def index
    @user = current_user
  end

  def new
    @user = User.new
  end

  def show
    if params.include?(:id)
       @user = User.find(params[:id])
      if cannot? :read, @user
        redirect_to user_url(current_user)
      end
    else
      redirect_to user_url(current_user)
    end
  end

  def create
    params[:user][:user_type] = "admin"
    params[:user][:account_status] = "active"
    @user = User.new(params[:user])
    @company = Company.new(name: params[:company][:company_name])
    begin

      ActiveRecord::Base.transaction do

        @user.save
        @user.update_attributes(manager_id: @user.id)
        @company.admin_id = @user.id
        @company.save

        raise "invalid" unless @user.valid? && @company.valid?
      end
    rescue
      flash[:errors] =  @user.errors.full_messages
      flash[:errors].concat(@company.errors.full_messages)
      redirect_to new_user_url
    else
      self.current_user = @user
      redirect_to users_url
    end
  end

  def edit
    @user = User.find(params[:id])
    if cannot? :edit, @user
      redirect_to users_url
    else
      render :edit
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to edit_user_url(@user)
    end

  end

  def add_employee
    render :add_employee
  end

  def create_employee
    params[:user][:manager_id] = current_user.id
    params[:user][:account_status] = "pending"
    @user = User.new(params[:user])
    @user.reset_password
    if @user.save
      UserMailer.confirmation_email(@user).deliver
      flash[:error] = "The code is #{@user.session_token}"
      redirect_to user_url(current_user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to add_employee_user_url(current_user)
    end
  end

  def list_employees
    @user = current_user
    @employees = @user.employees
    render :list_employees
  end

  def confirm_user
    @user = User.find(params[:user_id])
    render :confirm_user
  end

  def update_confirmed
    @user = User.find(params[:id])
    if @user && @user.session_token == params[:code]
      @user.account_status = "active"
      @user.password = params[:user][:password]
      @user.save
      flash[:errors] = ["Please update your account information and change your password."]
      redirect_to edit_user_url(@user)
    else
      flash[:errors] = ["User not found"]
      redirect_to new_session_url
    end
  end


end
