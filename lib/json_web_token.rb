# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = 'very_secret'

  def self.encode(payload)
    payload[:expires_at] = 24.hours.from_now.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
