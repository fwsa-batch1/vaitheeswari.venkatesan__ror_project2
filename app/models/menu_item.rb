class MenuItem < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, :price, presence: true
  belongs_to :menu_category

  def self.active
    all.where(status: true)
  end
  def self.not_active
    all.where(status: false)
  end
end
