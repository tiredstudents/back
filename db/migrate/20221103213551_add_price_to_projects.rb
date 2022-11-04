# frozen_string_literal: true

class AddPriceToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :price, :integer
  end
end
