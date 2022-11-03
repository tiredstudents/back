# frozen_string_literal: true

class Grade < ApplicationRecord
  validates :specialization, presence: true
end
