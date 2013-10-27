class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to(dashboard_path, flash: {success: 'Your profile was successfully updated.'})
    else
      render action: "edit"
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end
end