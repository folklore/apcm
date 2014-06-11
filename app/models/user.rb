class User < ActiveRecord::Base

  attr_accessible :name, :email, :city_id
  attr_accessible :name, :email, :city_id, :is_admin, as: :admin

  validates :name, :email, :city_id,
             presence: true

  validates :email,
             format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
             length: { maximum: 100 },
             allow_blank: true

  validates :is_admin,
             inclusion: { in: [true, false] }

  validates :city_id,
             numericality: { only_integer: true,
                             greater_than_or_equal_to: 1 },
             allow_blank: true

  belongs_to :city

  has_many :notes

  def citizen?(city_id) # authorize
    self.city_id == city_id.to_i
  end

  def can?(user_id)
   self.id == user_id or self.is_admin?
  end

end