class Location < ApplicationRecord
  belongs_to :user
  has_many :forecasts

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
