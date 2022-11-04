# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < Api::V1::BaseController
      load_and_authorize_resource class: 'Candidate'

      before_action :find_vacancy, only: %i[index create]
      before_action :find_candidate, only: %i[show update destroy vacancies]

      def index
        @candidates = @vacancy.candidates

        render json: @candidates, each_serializer: CandidateSerializer, status: 200
      end

      def vacancies
        @vacancies = @candidate.vacancies

        render json: @vacancies, each_serializer: VacancySerializer, status: 200
      end

      def show
        render json: @candidate, serializer: CandidateSerializer, status: 200
      end

      def create
        @candidate = Candidate.find_by(candidate_params) || Candidate.new(candidate_params)

        if @candidate.save
          CandidateVacancy.create(vacancy_id: @vacancy.id, candidate_id: @candidate.id)
          render json: @candidate, serializer: CandidateSerializer, status: :created
        else
          render json: @candidate.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        if @candidate.update(candidate_params)
          render json: @candidate, serializer: CandidateSerializer, status: :created
        else
          render json: @candidate.errors.full_messages, status: :unprocessable_entity
        end
      end

      def destroy
        if @candidate.destroy
          render json: 'Candidate was deleted', status: 200
        else
          render json: @candidate.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def find_vacancy
        @vacancy = Vacancy.find(params[:vacancy_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def find_candidate
        @candidate = Candidate.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Resource was not found' }, status: 404
      end

      def candidate_params
        {
          first_name: params[:first_name],
          last_name: params[:last_name]
        }
      end
    end
  end
end
