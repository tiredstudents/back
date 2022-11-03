# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, :first_name, :last_name, :phone, :post, :is_resource, presence: true

  before_save :crypt_password

  def self.authenticate(email, password)
    u = find_by(email: email)
    u&.send(:authed?, password) ? u : nil
  end

  private

  def crypt_password
    return if password.blank?

    self.salt = Digest::SHA1.hexdigest("--#{Time.zone.now}--#{email}--#{Kernel.rand}") if new_record?
    self.crypted_password = encrypt(password)
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authed?(password)
    crypted_password == encrypt(password)
  end
end
