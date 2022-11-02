class CreateProject < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.datetime :start_date
      t.datetime :estimated_end_date, null: false
      t.datetime :end_date
      t.string :status

      t.references :owner, foreign_key: { to_table: :users }
      t.references :manager, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
