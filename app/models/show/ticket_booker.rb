class Show::TicketBooker
  extend ActiveModel::Naming
  attr_accessor :book_tickets_attributes
  attr_accessor :tickets # output
  attr_accessor :show

  attr_reader :id, :ticket_count, :name, :phone, :ticket

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  attr_reader :errors

  def valid?
    show_id = book_tickets_attributes[:id]
    ticket_count = book_tickets_attributes[:ticket_count]
    is_valid = false

    if !show_id.present?
      errors.add(:id, :blank, message: "Id is required")
    end
    if !ticket_count.present?
      errors.add(:ticket_count, :blank, message: "ticket_count is required")
    end
    if !book_tickets_attributes[:name].present?
      errors.add(:name, :blank, message: "name is required")
    end
    if !book_tickets_attributes[:phone].present?
      errors.add(:phone, :blank, message: "phone is required")
    end
    if ticket_count.present? && (ticket_count < 0 || ticket_count > 10)
      errors.add(:ticket_count, :blank, message: "Tickets count invalid")
    end

    self.show = Show.find_by_id(show_id)

    if errors.count > 0
      return false
    else
      if self.show != nil
        if self.show.tickets.available.count >= ticket_count
          return true
        else
          errors.add(:ticket, :blank, message: "Tickets sold out")
        end
      else
        errors.add(:id, :blank, message: "Invalid show id")
      end
    end
    return is_valid
  end

  def book
    return false unless valid?
    name = book_tickets_attributes[:name]
    phone = book_tickets_attributes[:phone]
    ticket_count = book_tickets_attributes[:ticket_count]
    buyer = Buyer.create(name: name, phone: phone)
    Ticket.transaction do
      tickets_to_be_sold = self.show.tickets.available.order(:ticket_number).limit(ticket_count)
      tickets_to_be_sold.lock.map do |ticket| # lock ensure no other thread updates these tickets
        # sleep(0.1) # delay to encounter concurrency problems
        ticket.update(buyer: buyer, status: :sold)
      end
    end
    self.tickets = buyer.tickets
    return true
  end

  def as_errors_json
    return errors.as_pretty_json
  end

  # The following methods are needed to be minimally implemented

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end
end
