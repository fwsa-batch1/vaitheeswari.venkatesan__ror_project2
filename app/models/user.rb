class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :orders
  has_secure_password

  def is_owner?
    owner = role == "Owner" ? true : false
  end

  def is_clerk?
    clerk = role == "Clerk" ? true : false
  end

  def self.clerks
    all.where(role: "Clerk")
  end

  def self.customers
    all.where(role: "Customer")
  end

  def change_role
    if role == "Customer"
      self.role = "Clerk"
    else
      self.role = "Customer"
    end
    save!
  end
end
