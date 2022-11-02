# frozen_string_literal: true

class CreateCandidateVacancy < ActiveRecord::Migration[6.1]
  def change
    create_table :candidate_vacancies do |t|
      t.references :candidate, foreign_key: true
      t.references :vacancy, foreign_key: true

      t.timestamps
    end
  end
end
