# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate

      def authenticate
        header = request.headers['Authorization']
        api_token = header.split(' ').last if header

        return render json: { error: 'Token is required' }, status: :unauthorized if api_token.nil?

        begin
          decoded = JsonWebToken.decode(header)
          if Time.zone.at(decoded['expires_at']) < Time.zone.now
            render json: { errors: 'Token expired' },
                   status: :unauthorized
          end

          @current_user = User.find(decoded['user_id'])
        rescue ActiveRecord::RecordNotFound
          render json: { errors: 'Incorrect token' }, status: :unauthorized
        rescue JWT::DecodeError
          render json: { errors: 'Invalid token' }, status: :unauthorized
        end
      end

      attr_reader :current_user
    end
  end
end
