class Hospital < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :token_authenticatable

  has_and_belongs_to_many :doctors
  has_and_belongs_to_many :patients
  has_many :ratings, as: :rateable
  has_many :procedures_hospitals
  has_many :procedures, through: :procedures_hospitals , dependent: :destroy
  has_many :authentication_tokens,as: :authenticable, dependent: :destroy
  validates :email,:name, :phone_number, :presence =>true
  validates_uniqueness_of :email, :phone_number
  has_many :image, as: :imageable, dependent: :destroy
end
