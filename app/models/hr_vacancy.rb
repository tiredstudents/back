# frozen_string_literal: true

class HrVacancy < ApplicationRecord
  self.table_name = 'vacancy_hrs'

  validates :start_date, :finish_date, presence: true
  validate :check_hr

  belongs_to :vacancy, class_name: 'Vacancy', foreign_key: 'vacancy_id'
  belongs_to :hr, class_name: 'User', foreign_key: 'hr_id'

  private

  def check_hr
    errors.add(:hr_id, 'must be hr') unless User.find(hr_id).post == 'hr'
  end
end
