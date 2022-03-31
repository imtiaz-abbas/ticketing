class BookTicketsJob < ApplicationJob
  queue_as :high

  def perform(show_id, number_of_tickets, buyer_name, buyer_phone)
    show = KnowmanShow.find_by(id: show_id)
    if show.tickets.available.count >= number_of_tickets
      buyer = Buyer.create(name: buyer_name, phone: buyer_phone)
      Ticket.transaction do
        tickets_to_be_sold = show.tickets.available.order(:ticket_number).limit(number_of_tickets)
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
