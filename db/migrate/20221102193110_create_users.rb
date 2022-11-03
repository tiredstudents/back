# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password, null: false
      t.string :salt
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :post, null: false
      t.boolean :is_resource, null: false

      t.timestamps null: false
    end
  end
end
