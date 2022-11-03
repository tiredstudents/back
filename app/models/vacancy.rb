# frozen_string_literal: true

class Vacancy < ApplicationRecord
  extend Enumerize

  STATUSES = %w[active closed completed].freeze

  validates :name, :status, presence: true
  enumerize :status, in: STATUSES

  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  # has_many :candidates, class_name: "CandidateVacancy", foreign_key: "project_id"
end
