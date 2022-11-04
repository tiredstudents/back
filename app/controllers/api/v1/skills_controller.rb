# frozen_string_literal: true

module Api
  module V1
    class SkillsController < Api::V1::BaseController
      def all
        user = User.find(params[:resource_id])
        names = user.skills.joins(:skill).select('skill_resources.*, skills.*').pluck(:name)
        levels = user.skills.joins(:skill).select('skill_resources.*, skills.*').pluck(:level)

        render json: Hash[names.zip(levels)], status: 200
      rescue StandardError => e
        render json: e.message, status: :unprocessable_entity
      end

      def create
        skill = Skill.find_by(name: params[:skill_name]) || Skill.create!(name: params[:skill_name])

        ResourceSkill.create!(level: params[:level],
                              skill_id: skill.id,
                              resource_id: params[:resource_id])

        render json: { name: params[:skill_name], level: params[:level] }, status: :created
      rescue StandardError => e
        render json: e.message, status: :unprocessable_entity
      end
    end
  end
end
