class Ticket < ApplicationRecord
  belongs_to :knowman_show
  belongs_to :buyer, optional: true
  enum status: [:sold, :available], _default: "available"
end
