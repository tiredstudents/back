# frozen_string_literal: true

class CreateProjectResource < ActiveRecord::Migration[6.1]
  def change
    create_table :project_resources do |t|
      t.datetime :start_date, null: false
      t.datetime :finish_date, null: false

      t.references :project, foreign_key: true
      t.references :vacancy, foreign_key: true
      t.references :resource, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
