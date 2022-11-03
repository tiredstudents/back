# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    class SessionController < Api::V1::BaseController
      skip_before_action :authenticate

      def create
        user = User.authenticate(params[:email], params[:password])
        return render json: { error: 'Incorrect login or password' }, status: :unauthorized unless user

        token = JsonWebToken.encode(user_id: user.id)

        render json: { api_token: token, expires_at: 24.hours.from_now }, status: :created
      end

      private

      def auth_params
        [params[:email], params[:password]]
      end
    end
  end
end
