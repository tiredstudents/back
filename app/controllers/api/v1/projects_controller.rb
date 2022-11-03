# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      def index
        render json: { message: 'yes' }, status: 200
      end
    end
  end
end
