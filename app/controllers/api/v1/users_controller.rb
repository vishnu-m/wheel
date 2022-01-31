# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :authenticate_user_using_x_auth_token, only: :create

  before_action :set_user!, only: %i[show destroy]

  def show
    render status: :ok, json: @user
  end

  def create
    user = User.create!(user_params)
    render status: :ok, json: { user: user, auth_token: user.authentication_token }
  end

  def destroy
    @user.destroy!
    respond_with_success(t("successfully_destroyed", count: 1, entity: "User"))
  end

  private

    def set_user!
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
end
