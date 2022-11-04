# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :phone, :post, :manager_id
end
