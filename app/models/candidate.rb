# frozen_string_literal: true

class Candidate < ApplicationRecord
  validates :first_name, :last_name, presence: true

  has_many :vacancies, class_name: 'CandidateVacancy', foreign_key: 'candidate_id'
end
