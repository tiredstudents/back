# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      load_and_authorize_resource class: 'Project'

      before_action :find_project, only: %i[show update finish free_resource resources]
      before_action :find_resource, only: %i[free_resource]

      def index
        @projects = Project.all

        unless search_params.empty?
          @projects = @projects.where('name LIKE ?', "%#{search_params[:name]}%") if search_params[:name]
          if search_params[:estimated_end_date_before]
            @projects = @projects.where("estimated_end_date < '#{search_params[:estimated_end_date_before]}'")
          end
          if search_params[:estimated_end_date_after]
            @projects = @projects.where("estimated_end_after < '#{search_params[:estimated_end_date_after]}'")
          end
          if search_params[:start_date_before]
            @projects = @projects.where("start_date_before < '#{search_params[:start_date_before]}'")
          end
          if search_params[:start_date_after]
            @projects = @projects.where("start_date_after < '#{search_params[:start_date_after]}'")
          end
          if search_params[:end_date_before]
            @projects = @projects.where("end_date_before < '#{search_params[:end_date_before]}'")
          end
          if search_params[:end_date_after]
            @projects = @projects.where("end_date_after < '#{search_params[:end_date_after]}'")
          end
          @projects = @projects.where(status: search_params[:status]) if search_params[:status]
          @projects = @projects.where(owner_id: search_params[:owner_id]) if search_params[:owner_id]
          @projects = @projects.where(manager_id: search_params[:manger_id]) if search_params[:manger_id]
        end

        render json: @projects, each_serializer: ProjectSerializer, status: 200
      end

      def resources
        @resources = @project.resources

        @resources = @resources.where('finish_date > ?', Time.zone.now) if params[:current]

        render json: @resources, each_serializer: UserSerializer, status: 200
      end

      def show
        render json: @project, serializer: ProjectSerializer, status: 200
      end

      def create
        @project = current_user.owned_projects.build(project_params)

        if @project.save
          render json: @project, serializer: ProjectSerializer, status: :created
        else
          render json: @project.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        if @project.update(project_params)
          render json: @project, serializer: ProjectSerializer, status: :created
        else
          render json: @project.errors.full_messages, status: :unprocessable_entity
        end
      end

      def free_resource
        @record = ResourceProject.find_by(resource_id: @resource.id, project_id: @project.id)

        if @record.update(finish_date: Time.zone.now)
          render json: "Resource ##{@resource.id} was unassigned from project ##{@project.id}", status: 201
        else
          render json: 'Incorrect request', status: 404
        end
      end

      def finish
        if @project.finish!
          render json: 'Project was marked as finished', status: 200
        else
          render json: @project.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def find_project
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def find_resource
        @resource = User.find(params[:resource_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def project_params
        start_date = begin
          Date.parse(params[:start_date])
        rescue StandardError
          nil
        end
        end_date = begin
          Date.parse(params[:end_date])
        rescue StandardError
          nil
        end
        estimated_end_date = begin
          Date.parse(params[:estimated_end_date])
        rescue StandardError
          nil
        end

        {
          name: params[:name],
          start_date: start_date,
          estimated_end_date: estimated_end_date,
          end_date: end_date,
          status: params[:status],
          price: params[:price],
          manager_id: params[:manager_id]
        }
      end

      def search_params
        estimated_end_date_before = begin
          Date.parse(params[:estimated_end_date_before]).beginning_of_day&.to_s
        rescue StandardError
          nil
        end
        estimated_end_date_after = begin
          Date.parse(params[:estimated_end_date_after]).end_of_day&.to_s
        rescue StandardError
          nil
        end
        start_date_before = begin
          Date.parse(params[:start_date_before]).beginning_of_day&.to_s
        rescue StandardError
          nil
        end
        start_date_after = begin
          Date.parse(params[:start_date_after]).end_of_day&.to_s
        rescue StandardError
          nil
        end
        end_date_before = begin
          Date.parse(params[:end_date_before]).beginning_of_day&.to_s
        rescue StandardError
          nil
        end
        end_date_after = begin
          Date.parse(params[:end_date_after]).endof_day&.to_s
        rescue StandardError
          nil
        end

        {
          name: params[:name],
          estimated_end_date_before: estimated_end_date_before,
          estimated_end_date_after: estimated_end_date_after,
          start_date_before: start_date_before,
          start_date_after: start_date_after,
          end_date_before: end_date_before,
          end_date_after: end_date_after,
          status: params[:status],
          owner_id: params[:owner_id],
          manger_id: params[:manager_id]
        }
      end
    end
  end
end
