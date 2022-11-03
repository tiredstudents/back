# frozen_string_literal: true

class Project < ApplicationRecord
  extend Enumerize

  ACTIVE_STATUSES = %w[inactive development stopped].freeze

  validates :name, :estimated_end_date, presence: true
  enumerize :status, in: ACTIVE_STATUSES

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'
  has_many :vacancies, class_name: 'Vacancy', foreign_key: 'project_id'

  before_create do
    self.status = 'inactive'
  end

  def finish!(user)
    # владелец проекта может завершить проект
    update(status: 'finished') if user == owner
    # высвободить все ресурсы
  end
end
