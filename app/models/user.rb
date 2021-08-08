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

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    MailWorker.perform_async(self.id,"forgot_password")
    # UserMailer.forgot_password(self).deliver # This sends an e-mail with a link for the user to reset the password
  end

  # This generates a random password reset token for the user
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
