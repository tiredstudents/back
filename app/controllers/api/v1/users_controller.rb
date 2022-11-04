# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      load_and_authorize_resource class: 'User'

      before_action :find_user, only: %i[show update fire vacancies projects
                                         owned_projects managed_projects
                                         managed_vacancies]

      def index
        @users = if current_user.post == 'manager'
                   current_user.slaves
                 else
                   User.all
                 end
        @users = @users.where(is_active: true)

        unless search_params.empty?
          @users = @users.where('email LIKE ?', "%#{search_params[:email]}%")
                         .where('first_name LIKE ?', "%#{search_params[:first_name]}%")
                         .where('last_name LIKE ?', "%#{search_params[:last_name]}%")
        end

        render json: @users, each_serializer: UserSerializer, status: 200
      end

      def show
        render json: @user, serializer: UserSerializer, status: 200
      end

      def projects
        @projects = @user.projects

        @projects = @projects.where('finish_date > ?', Time.zone.now) if params[:current]

        render json: @projects, each_serializer: ProjectSerializer, status: 200
      end

      def owned_projects
        @projects = @user.owned_projects

        render json: @projects, each_serializer: ProjectSerializer, status: 200
      end

      def managed_projects
        @projects = @user.managed_projects

        render json: @projects, each_serializer: ProjectSerializer, status: 200
      end

      def managed_vacancies
        @vacancies = @user.vacancies

        @vacancies = @vacancies.where('finish_date > ?', Time.zone.now) if params[:current]

        render json: @vacancies, each_serializer: VacancySerializer, status: 200
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, serializer: UserSerializer, status: :created
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user, serializer: UserSerializer, status: :created
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      def fire
        if @user.fire!
          render json: 'User was marked as inactive', status: 200
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def find_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def user_params
        is_resource = params[:is_resource].nil? ? true : params[:is_resource]

        {
          email: params[:email],
          first_name: params[:first_name],
          last_name: params[:last_name],
          password: params[:password],
          phone: params[:phone],
          post: params[:post],
          is_resource: is_resource,
          manager_id: params[:manager_id]
        }
      end

      def search_params
        {
          email: params[:email],
          first_name: params[:first_name],
          last_name: params[:last_name]
        }
      end
    end
  end
end
