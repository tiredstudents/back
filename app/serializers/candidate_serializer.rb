# frozen_string_literal: true

class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name
end
