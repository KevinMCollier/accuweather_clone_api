class Forecast < ApplicationRecord
  belongs_to :location
  belongs_to :user

  validates :temperature, presence: true
  validates :condition, presence: true
end
