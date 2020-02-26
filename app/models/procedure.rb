class Procedure < ApplicationRecord
  has_many :procedures_hospitals
  has_many :hospitals, through: :procedures_hospitals
  # has_many :doctors
end
