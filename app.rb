require "sinatra"
require "sinatra/activerecord"
require_relative 'models/post'
require_relative 'models/category'
require 'SecureRandom'
require 'sinatra/flash'  
require 'sinatra/redirect_with_flash' 

enable :sessions

set :database, "sqlite3:///craigslist.db"

get '/' do
  @categories = Category.all
  erb :home
end

get '/category/:name/' do
  @c = Category.find_by_name(params[:name])
  @posts = @c.posts.all
  erb :posts
end

get '/post/:id/' do
  @post = Post.find(params[:id])
  erb :post_content
end

post '/category/:name/' do
  @c = Category.find_by_name(params[:name])

  begin
  edit_id = SecureRandom.hex(5)
  end while Post.find_by_edit_id(edit_id) != nil

  post = Post.create(title: params[:title], content: params[:content], email: params[:email], edit_id: edit_id)
  @c.posts << post
  @posts = @c.posts.all
 flash[:success] = "Your edit url is category/post/#{post.id}/edit?key=#{edit_id}"
  redirect "/category/#{@c.name}/"
end

put '/category/post/:id' do
  @post = Post.find(params[:id])
  @post.title = params[:title]
  @post.content = params[:content]
  erb :post_content
end

get '/category/post/:id/edit' do 
  key = params[:key].sub("\/", "")  
  @post = Post.find_by_edit_id(key)
  unless @post.nil?
    erb :post_edit
  else
    "go fuck yourself"  
  end 
end
