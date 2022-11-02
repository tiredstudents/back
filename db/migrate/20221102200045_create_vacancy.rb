# frozen_string_literal: true

class CreateVacancy < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancies do |t|
      t.string :name, null: false
      t.string :status, null: false
      t.string :required_grade

      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
