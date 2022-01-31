# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_using_x_auth_token
    before_action :authenticate_user!
  end

  private

    def authenticate_user_using_x_auth_token
      user_email = request.headers["X-Auth-Email"]
      auth_token = request.headers["X-Auth-Token"].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, auth_token)
        sign_in user, store: false
      else
        respond_with_error("Could not authenticate with the provided credentials", 401)
      end
      end
end
