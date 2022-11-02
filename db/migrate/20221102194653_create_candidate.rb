# frozen_string_literal: true

class CreateCandidate < ActiveRecord::Migration[6.1]
  def change
    create_table :candidates do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end
end
