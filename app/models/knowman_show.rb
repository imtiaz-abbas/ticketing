class KnowmanShow < ApplicationRecord
  has_many :tickets
  enum status: [:as_per_schedule, :cancelled], _default: "as_per_schedule"

  before_create :setup_show_date
  after_create_commit :enqueue_ticket_creation_jobs

  def book_tickets_exp
    BookTicketsJob.perform_later(self.id, 5, (0...5).map { (65 + rand(26)).chr }.join, (0...9).map { (rand(10)) }.join)
  end

  def book_tickets(number_of_tickets, buyer_name, buyer_phone)
    if number_of_tickets < 0 || number_of_tickets > 10
      # error : ticket count invalid
    else
      if self.tickets.available.count >= number_of_tickets
        buyer = Buyer.create(name: buyer_name, phone: buyer_phone)
        Ticket.transaction do
          tickets_to_be_sold = self.tickets.available.order(:ticket_number).limit(number_of_tickets)
          tickets_to_be_sold.lock.map do |ticket| # lock ensure no other thread updates these tickets
            sleep(1) # delay to encounter concurrency problems
            ticket.update(buyer: buyer, status: :sold)
          end
        end
      else
        # error : tickets sold out
      end
    end
  end

  protected

  def setup_show_date
    self.date = DateTime.now.change({ hour: 16, minute: 00 })
  end

  def enqueue_ticket_creation_jobs
    1.upto(250) do |ticket_number|
      TicketGenerationJob.perform_later(id, ticket_number)
    end
  end
end
