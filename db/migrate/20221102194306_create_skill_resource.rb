class CreateSkillResource < ActiveRecord::Migration[6.1]
  def change
    create_table :skill_resources do |t|
      t.string :comment
      t.integer :level, null: false

      t.timestamps
    end
  end
end
