# frozen_string_literal: true

class HrVacancy < ApplicationRecord
  self.table_name = 'vacancy_hrs'

  validates :start_date, :finish_date, presence: true

  belongs_to :vacancy, class_name: 'Vacancy', foreign_key: 'vacancy_id'
  belongs_to :hr, class_name: 'User', foreign_key: 'hr_id'
end
