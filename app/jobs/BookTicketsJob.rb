class BookTicketsJob < ApplicationJob
  queue_as :high

  def perform(show_id, number_of_tickets, name, phone)
    booker = Show::TicketBooker.new
    booker.book_tickets_attributes = { id: show_id, ticket_count: number_of_tickets, name: name, phone: phone }
    if booker.book
      puts "booked ticket for" + name
    else
      puts "unable to book ticket for" + name
    end
  end
end
