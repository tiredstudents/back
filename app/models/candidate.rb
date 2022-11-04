# frozen_string_literal: true

class Candidate < ApplicationRecord
  validates :first_name, :last_name, presence: true

  has_many :candidate_vacancies, class_name: 'CandidateVacancy', foreign_key: 'candidate_id', dependent: :destroy
  has_many :vacancies, through: :candidate_vacancies
end
