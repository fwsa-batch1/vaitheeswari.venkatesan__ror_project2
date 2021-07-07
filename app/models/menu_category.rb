class MenuCategory < ActiveRecord::Base
  has_many :menu_items
  validates :menu_category_name, presence: true, uniqueness: true

  def self.active
    all.where(status: true)
  end
  def self.not_active
    all.where(status: false)
  end
end
