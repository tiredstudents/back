class CreateVacancyHr < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancy_hrs do |t|
      t.datetime :start_date, null: false
      t.datetime :finish_date, null: false
      
      t.references :vacancy, foreign_key: true
      t.references :hr, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
