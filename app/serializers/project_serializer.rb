# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :estimated_end_date, :end_date,
             :status, :owner_id, :manager_id, :price
end
