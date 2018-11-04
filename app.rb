require 'sinatra'
require 'sinatra/activerecord'

require './models'

set :database, 'sqlite3:rumblerDB.sqlite3'
set :sessions, true


def current_blog
  @blog = Blog.find(params[:id])
end

def current_user
  if (session[:user_id])
    @user = User.find(session[:user_id])
  end
end

get "/" do
  @blogs = Blog.all
  @users = User.all
  erb :index
end

post "/create_blog" do
  if !session[:user_id]
    redirect "/"
  end
title = params[:title]
content = params[:content]
user = User.find(session[:user_id])
Blog.create(title: title, content: content, user_id: user.id,  )
redirect "/"
end

get "/new" do
  erb :new
end

get "/blogs/:id" do
  current_blog
  erb :show
end


get "/blogs/:id/edit" do
  current_blog
  erb :edit
end

post "/update/:id" do
  current_blog
    if @blog.update(title: params[:title], content: params[:content])
      redirect "/"
    else
      erb :"/blogs/<%=@blog.id%>/edit"
    end
end

post "/destroy/:id" do

  current_blog
  if @blog.destroy
    redirect "/"
  end
end

post "/signup" do
  username = params[:username]
  password = params[:password]
  fname = params[:fname]
  lname = params[:lname]
  email = params[:email]
  user = User.new(username: username, password: password, fname:fname, lname: lname, email: email)
  if user.save
    redirect "/"
  else
    erb :index
  end
end

get "/hello" do
  erb :hello
end

post "/login" do
  user = User.where(username: params[:username]).first
  if user.password == params[:password]
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    erb :index
  end
end

get "/users/:id" do
  @user = User.find(params[:id])
  erb :user
end

post "/logout" do
  session[:user_id] = nil
  redirect "/"
  erb :index
end
