# frozen_string_literal: true

module Api
  module V1
    class VacanciesController < Api::V1::BaseController
      load_and_authorize_resource class: 'Vacancy'

      before_action :find_vacancy, only: %i[show update candidates close complete assign_for_hr unassign]
      before_action :find_project, only: %i[index create]
      before_action :find_resource, only: %i[complete]

      def index
        @vacancies = @project.vacancies.all

        unless search_params.empty?
          @vacancies = @vacancies.where(status: search_params[:status]) if search_params[:status]
          @vacancies = @vacancies.where(project_id: search_params[:project_id]) if search_params[:project_id]
        end

        render json: @vacancies, each_serializer: VacancySerializer, status: 200
      end

      def show
        render json: @vacancy, serializer: VacancySerializer, status: 200
      end

      def assign_for_hr
        user = User.find(params[:user_id])

        begin
          HrVacancy.create!(hr_id: user.id,
                            vacancy_id: @vacancy.id,
                            start_date: Time.zone.now,
                            finish_date: @vacancy.project.estimated_end_date)
          render json: 'Assigned', status: :created
        rescue StandardError
          render json: 'Invalid request', status: 404
        end
      end

      def unassign
        user = User.find(params[:user_id])

        begin
          record = HrVacancy.find_by(hr_id: user.id, vacancy_id: @vacancy.id)
          record.update(finish_date: Time.zone.now)
          render json: 'Unassigned', status: :created
        rescue StandardError
          render json: 'Invalid request', status: :created
        end
      end

      def create
        @vacancy = @project.vacancies.build(vacancy_params)

        if @vacancy.save
          render json: @vacancy, serializer: VacancySerializer, status: :created
        else
          render json: @vacancy.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        if @vacancy.update(vacancy_params)
          render json: @vacancy, serializer: VacancySerializer, status: :created
        else
          render json: @vacancy.errors.full_messages, status: :unprocessable_entity
        end
      end

      def close
        if @vacancy.update(status: 'closed')
          render json: 'Vacancy was closed', status: 200
        else
          render json: 'Incorrect request', status: 404
        end
      end

      def complete
        ResourceProject.create!(resource_id: @resource.id,
                                project_id: @vacancy.project.id,
                                start_date: Time.zone.now,
                                finish_date: @vacancy.project.estimated_end_date)
        @vacancy.update!(status: 'completed')
        render json: "Resource ##{@resource.id} was assigned to project ##{@vacancy.project.id}", status: 201
      rescue StandardError
        render json: 'Incorrect request', status: 404
      end

      private

      def find_vacancy
        @vacancy = Vacancy.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def find_project
        @project = Project.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def find_resource
        @resource = User.find(params[:resource_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def vacancy_params
        {
          name: params[:name],
          status: params[:status],
          required_grade: params[:required_grade]
        }
      end

      def search_params
        {
          status: params[:status],
          project_id: params[:project_id]
        }
      end
    end
  end
end
