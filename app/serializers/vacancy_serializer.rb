# frozen_string_literal: true

class VacancySerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :required_grade, :project_id
end
