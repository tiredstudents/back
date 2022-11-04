# frozen_string_literal: true

class Vacancy < ApplicationRecord
  extend Enumerize

  STATUSES = %w[active closed completed].freeze

  validates :name, :status, presence: true
  enumerize :status, in: STATUSES

  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'

  has_many :candidate_vacancies, class_name: 'CandidateVacancy', foreign_key: 'vacancy_id', dependent: :destroy
  has_many :candidates, through: :candidate_vacancies

  has_many :managed_vacancies, class_name: 'HrVacancy', foreign_key: 'vacancy_id', dependent: :nullify
  has_many :hrs, through: :managed_vacancies

  before_create do
    self.status = 'active'
  end
end
