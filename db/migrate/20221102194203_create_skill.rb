# frozen_string_literal: true

class CreateSkill < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
