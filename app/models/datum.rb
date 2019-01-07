class Datum < ApplicationRecord
  has_many :categories
  has_many :headers
end
