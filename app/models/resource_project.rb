# frozen_string_literal: true

class ResourceProject < ApplicationRecord
  self.table_name = 'project_resources'

  validates :start_date, :finish_date, presence: true

  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  belongs_to :resource, class_name: 'User', foreign_key: 'resource_id'
  belongs_to :vacancy, class_name: 'Vacancy', foreign_key: 'vacancy_id'
end
