class BookTicketsJob < ApplicationJob
  queue_as :high

  def perform(show_id, number_of_tickets, name, phone)
    show = Show.find_by(id: show_id)
    if show.tickets.available.count >= number_of_tickets
      buyer = Buyer.create(name: name, phone: phone)
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
