# frozen_string_literal: true

class AddManagerToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :manager, foreign_key: { to_table: :users }
  end
end
