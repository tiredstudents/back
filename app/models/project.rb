# frozen_string_literal: true

class Project < ApplicationRecord
  extend Enumerize

  STATUSES = %w[inactive development stopped finished].freeze

  validates :name, :estimated_end_date, presence: true
  enumerize :status, in: STATUSES

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true
  has_many :vacancies, class_name: 'Vacancy', foreign_key: 'project_id'

  has_many :resource_projects, class_name: 'ResourceProject', foreign_key: 'project_id'
  has_many :resources, through: :resource_projects

  before_create do
    self.status = 'inactive'
  end

  def finish!
    # владелец проекта может завершить проект
    return if status == 'finished'

    update(status: 'finished')
    resource_projects.update_all(finish_date: Time.zone.now)
  end
end
