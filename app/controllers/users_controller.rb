class UsersController < ApplicationController
  def index
    @all_users = User.find(:all)
  end

  def show
    @cur_user = User.find(params[:id])
  end

  def login
  end

  def post_login
    @session_user = User.find_by_login(params[:login])
    if (@session_user.nil? || !@session_user.password_valid?(params[:password]))
      redirect_to action: 'login', alert: "Invalid login."
    else
      session[:user_id] = @session_user.id
      redirect_to root_path 
    end
  end

  def logout
    reset_session
    redirect_to action: 'login', notice: "You have logged out."
  end

  def new
    @new_user = User.new
  end

  def create
    @new_user = User.new
    @new_user.first_name = params[:first]
    @new_user.last_name = params[:last]
    @new_user.login = params[:login]
    @new_user.email = params[:email]
    @new_user.password = params[:password]
    @new_user.password_confirmation = params[:password_confirmation]

    for user in User.find(:all)
      if user.login == params[:login]
        redirect_to action: 'new', alert: "Username taken."
        return
      end
    end

    if @new_user.valid?
      @new_user.save
      redirect_to action: 'login', notice: "Thank you for registering!"
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end
end
