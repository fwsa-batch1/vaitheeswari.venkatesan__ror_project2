class MenuItem < ActiveRecord::Base
  belongs_to :menu_category

  def display_string
    "#{id} #{menu_category_id} #{name} #{description} #{price} #{quantity_available} #{status}"
  end

  def self.active
    all.where(status: true)
  end
  def self.not_active
    all.where(status: false)
  end
end
