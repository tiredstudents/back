# frozen_string_literal: true

class Skill < ApplicationRecord
  validates :name, presence: true
end
