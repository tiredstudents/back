# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize
  attr_accessor :password

  POSTS = ['project owner', 'project manager', 'hr', 'manager', 'employee', 'support'].freeze

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, on: :create
  validates :first_name, :last_name, :phone, :post, :is_resource, presence: true
  enumerize :post, in: POSTS

  before_create :crypt_password

  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true
  has_many :slaves, class_name: 'User', foreign_key: 'manager_id', dependent: :nullify
  has_many :owned_projects, class_name: 'Project', foreign_key: 'owner_id', dependent: :nullify
  has_many :managed_projects, class_name: 'Project', foreign_key: 'manager_id', dependent: :nullify
  has_many :managed_vacancies, class_name: 'HrVacancy', foreign_key: 'hr_id', dependent: :nullify

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
