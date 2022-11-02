class CreateGradeTable < ActiveRecord::Migration[6.1]
  def change
    create_table :grades do |t|
      t.string :specialization, null: false

      t.timestamps
    end
  end
end
