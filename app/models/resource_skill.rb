# frozen_string_literal: true

class ResourceSkill < ApplicationRecord
  self.table_name = 'skill_resources'

  extend Enumerize

  LEVELS = [0, 1, 2, 3].freeze

  validates :level, presence: true
  enumerize :level, in: LEVELS
end
