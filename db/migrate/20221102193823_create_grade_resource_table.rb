# frozen_string_literal: true

class CreateGradeResourceTable < ActiveRecord::Migration[6.1]
  def change
    create_table :grade_resources do |t|
      t.integer :level
      t.references :grade, foreign_key: { to_table: :grades }
      t.references :resource, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
