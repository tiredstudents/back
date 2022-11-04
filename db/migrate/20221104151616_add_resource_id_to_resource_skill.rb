# frozen_string_literal: true

class AddResourceIdToResourceSkill < ActiveRecord::Migration[6.1]
  def change
    add_reference :skill_resources, :resource, foreign_key: { to_table: :users }
    add_reference :skill_resources, :skill, foreign_key: { to_table: :skills }
  end
end
