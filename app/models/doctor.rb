class Doctor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :token_authenticatable
  

  has_and_belongs_to_many :hospitals
  has_many :ratings, as: :rateable
  belongs_to :city
  has_many :authentication_tokens, as: :authenticable ,dependent: :destroy
  has_many :patients
  # belongs_to :procedure
  has_one :image, as: :imageable, dependent: :destroy
  validates :email, :first_name, :phone_number, :presence => true
  validates_uniqueness_of :email, :phone_number

end
