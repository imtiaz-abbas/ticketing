class Ticket < ApplicationRecord
  belongs_to :show
  belongs_to :buyer, optional: true

  enum status: [:sold, :available], _default: "available"

  validates :ticket_number, presence: true
end
