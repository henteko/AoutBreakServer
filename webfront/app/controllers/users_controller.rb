class UsersController < ApplicationController
  def login
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  def create
    name = params[:user][:name]
    password = params[:user][:password]

    admin = User.find_by_name_and_password(name, password)
    session[:user_id] = admin.id unless admin.nil?
    flash[:success] = 'Login Success!'
    redirect_to root_path
  end

  def edit
  end

  def update
    new_password = params[:user][:new_password]
    if new_password.blank?
      flash[:error] = 'Password Setting Error!'
      return redirect_to edit_users_path
    end

    @admin.password = new_password
    @admin.save

    flash[:success] = 'Password Setting Success!'
    redirect_to :back
  end
end
