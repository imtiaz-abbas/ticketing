class Api::ShowsController < Api::BaseController
  def index
    status_code = :unprocessable_entity
    shows = Show.all.order(:date)
    data = response_as :success, data: shows.as_json
    status_code = :ok
    render json: data, status: status_code
  end

  def book_tickets
    status_code = :unprocessable_entity
    booker = Show::TicketBooker.new
    booker.book_tickets_attributes = required_params
    if booker.book
      data = response_as :success, data: booker.tickets.as_json
      status_code = :ok
    else
      data = response_as :failure, data: booker.errors.as_pretty_json
    end
    render json: data, status: status_code
  end

  def required_params
    params.permit(:id, :ticket_count, :name, :phone)
  end
end
