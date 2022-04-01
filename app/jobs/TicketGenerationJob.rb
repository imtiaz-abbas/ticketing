class TicketGenerationJob < ApplicationJob
  queue_as :high

  def perform(show_id, ticket_number)
    show = Show.find_by(id: show_id)
    show.tickets.create(ticket_number: ticket_number)
  end
end
