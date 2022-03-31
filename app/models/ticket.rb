class Ticket < ApplicationRecord
  enum status: [:sold, :available], _default: "available"
end
