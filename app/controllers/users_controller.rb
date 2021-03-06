class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
    @user.groups.build
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    params[:user][:organizer] = true
    params[:group][:email] = "none@email.com"

    @user = User.new(user_params)
    @group_user = User.new(group_user_params)

    respond_to do |format|
      if @user.save && @group_user.save
        session[:user_id] = @user.id

        @group = GroupsUsers.find_by_user_id(@user.id)
        @group_member = GroupsUsers.new(group_id: @group.group_id, user_id: @group_user.id)
        @group_member.save

        format.html { redirect_to groups_path, success: t('flash.signup.added') }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :organizer, :password, :password_confirmation, :groups_attributes => [:name, :creation_date])
    end

    def group_user_params
      params.require(:group).permit(:username, :email, :organizer, :password, :password_confirmation)
    end
end
