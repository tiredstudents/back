# frozen_string_literal: true

module Api
  module V1
    class GradesController < Api::V1::BaseController
      load_and_authorize_resource class: 'Grade'

      def all
        user = User.find(params[:resource_id])
        names = user.grades.joins(:grade).select('grade_resources.*, grades.*').pluck(:specialization)
        levels = user.grades.joins(:grade).select('grade_resources.*, grades.*').pluck(:level)

        render json: Hash[names.zip(levels)], status: 200
      rescue StandardError => e
        render json: e.message, status: :unprocessable_entity
      end

      def create
        grade = Grade.find_by(specialization: params[:specialization]) || Grade.create!(specialization: params[:specialization])

        ResourceGrade.create!(level: params[:level],
                              grade_id: grade.id,
                              resource_id: params[:resource_id])

        render json: { name: params[:specialization], level: params[:level] }, status: :created
      rescue StandardError => e
        render json: e.message, status: :unprocessable_entity
      end
    end
  end
end
