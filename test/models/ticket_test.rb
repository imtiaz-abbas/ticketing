require "test_helper"

class TicketTest < ActiveSupport::TestCase
  test "should fail to create ticket without show" do
    ticket = Ticket.new(ticket_number: 1)
    assert_equal false, ticket.valid?
    assert_equal false, ticket.save
  end
  test "should fail to create ticket without ticket_number" do
    show = Show.new
    ticket = Ticket.new(show: show)
    assert_equal false, ticket.valid?
    assert_equal false, ticket.save
  end

  test "should sucessfully create ticket with ticket_number" do
    show = Show.new
    ticket = Ticket.new(ticket_number: 1, show: show)
    assert_equal true, ticket.valid?
    assert ticket.save
  end
end
