# frozen_string_literal: true

class CandidateVacancy < ApplicationRecord
  belongs_to :vacancy, class_name: 'Vacancy', foreign_key: 'vacancy_id'
  belongs_to :candidate, class_name: 'Candidate', foreign_key: 'candidate_id'

  validates_uniqueness_of :candidate_id, scope: [:vacancy_id]
end
