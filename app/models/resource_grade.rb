# frozen_string_literal: true

class ResourceGrade < ApplicationRecord
  self.table_name = 'grade_resources'

  LEVELS = [0, 1, 2, 3].freeze

  validates :level, presence: true
  enumerize :level, in: LEVELS
end
