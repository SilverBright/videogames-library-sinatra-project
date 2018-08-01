class UsersController < ApplicationController

  # get '/users/:slug' do
  #   @user = User.find_by_slug(params[:slug])
  #   @games = @user.games
  #     erb :'/users/show'

  get '/register' do
    if logged_in?
      redirect to "/"
      # erb :'users/register'
    else
      erb :'users/register'
    end
  end

  post '/register' do
   @user = User.create(username: params[:username], password: params[:password])
    if @user.valid?
      session[:user_id] = @user.id
      redirect "/games"
    elsif @user.invalid? && User.find_by(username: @user.username)
       flash[:error] = "That username is already taken, please choose another."
      redirect to '/register'
    else
        flash[:error] = "You must fill out all fields to sign up."
        redirect to '/register'
    end
  end


  # post '/register' do
  #   if params[:username] == "" || params[:password] == ""
  #     redirect to '/register'
  #   else
  #     @user = User.new(:username => params[:username], :password => params[:password])
  #     @user.save
  #     session[:user_id] = @user.id
  #     redirect to '/games'
  #   end
  # end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to '/register'
    end
  end

  post '/login' do
   @user = User.find_by(:username => params[:username])
   if @user && @user.authenticate(params[:password])
     session[:user_id] = @user.id
     # flash[:success] = "Welcome Back, #{@user.username}!"
     redirect to "/games"

   else
     flash[:error] = "Invalid username or password. Please try again."
     redirect '/login'
   end
 end


  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/login'
    end
  end

end

