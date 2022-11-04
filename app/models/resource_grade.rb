# frozen_string_literal: true

class ResourceGrade < ApplicationRecord
  self.table_name = 'grade_resources'

  extend Enumerize

  LEVELS = [0, 1, 2, 3].freeze

  validates :level, presence: true
  enumerize :level, in: LEVELS

  belongs_to :resource, class_name: 'User', foreign_key: 'resource_id'
  belongs_to :grade, class_name: 'Grade', foreign_key: 'grade_id'
end
