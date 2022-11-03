# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      def index
        render json: { message: 'yes' }, status: 200
      end
    end
  end
end
