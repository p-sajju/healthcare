class Patient < ApplicationRecord
  
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :token_authenticatable

    has_many :authentication_tokens,  as: :authenticable, dependent: :destroy   
  	has_one :image, as: :imageable, dependent: :destroy
    has_and_belongs_to_many :hospitals
    belongs_to :city
    belongs_to :doctor
    validates :email,:first_name, :phone_number, :presence => true
    validates_uniqueness_of :email, :phone_number
end
