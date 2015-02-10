module Users
 class UserController < ApplicationController
  # before_filter :authenticate_user!

 def index
    @user = User.includes(:roles)
    @users = @user.all
    # @tag = ActsAsTaggableOn::Tag.all
 end

  def edit
    # render('index')
  end

  
  def set_admin
    user = User.find(params[:user_id])
     user.roles.new(role: "admin") 
     user.save
    redirect_to users_user_index_path
  end
  
  def set_moderator
    user = User.find(params[:user_id])
    user.roles.new(role: "moderator") 
     user.save
    redirect_to users_user_index_path
  end

  def destroy
    user = User.find(params[:id]).roles
    user.first.destroy
    redirect_to users_user_index_path
  end
  
  def set_tags
    @user = User.find(params[:user_id]) 
    case params[:key]
     when "marked"
     @user.tag_list.add(params[:id])
     when "unmarked"
     @user.tag_list.remove(params[:id])
    end
    @user.save
    @list_tag = @user.tag_list
    render partial: "user" 
  end

 def show
  @user = User.find(params[:id])
  @tags = ActsAsTaggableOn::Tag.all
  @list = @user.tag_list
  #   redirect_to questions_path
  #   # unless @user == current_user
  #   #   redirect_to :back, :alert => "Access denied."
  #   # end
  end
 end
end

