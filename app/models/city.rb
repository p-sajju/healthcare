class City < ApplicationRecord
  has_many :hospitals
  belongs_to :country
  has_many :doctors
  validates :name, :presence =>true
end
