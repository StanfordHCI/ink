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
      redirect_to action: 'login'
    else
      session[:user_id] = @session_user.id
      redirect_to @session_user
    end
  end

  def logout
    reset_session
    redirect_to action: 'login'
  end

  def new
    @new_user = User.new
  end

  def create
    @new_user = User.new
    @new_user.first_name = params[:first]
    @new_user.last_name = params[:last]
    @new_user.login = params[:login]
    @new_user.password = params[:password]
    @new_user.password_confirmation = params[:password_confirmation]

    for user in User.find(:all)
      if user.login == params[:login]
        #throw error "username taken"
        redirect_to action: 'new'
        return
      end
    end

    if @new_user.valid?
      @new_user.save
      #show success message
      redirect_to action: 'login'
    else
      #throw error "invalid form"
      redirect_to action: 'new'
    end
  end
end
