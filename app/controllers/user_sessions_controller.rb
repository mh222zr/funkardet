class UserSessionsController < ApplicationController
  def new
    # Redirect to group page - dossen't work
    if session[:user_id]
      if !current_user.organizer
        if session[:group_member_id]
          redirect_to groups_path
        else
          redirect_to select_user_path
        end
      else
        redirect_to groups_path
      end
    end
  end

  def create
    user = User.find_by_username((params[:username]).downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      # If the user is an organizer, redirect to index.
      # Else make the user select a member from group_members
      if user.organizer
        flash[:success] = t('flash.login.logged-in')
        redirect_to groups_path
      else
        redirect_to select_user_path
      end
    else
      flash[:error] = t('flash.login.logged-in-error')
      render action: 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_path, notice: t('flash.login.logout')
  end

  def select_user
    @groups_users = GroupsUsers.find_by_user_id(session[:user_id])
  end

  def select_user_post
    session[:group_member_id] = params[:group_member]
    group_member = GroupMember.find_by_id(session[:group_member_id])

    redirect_to group_path(group_member.group_id)
  end
end
