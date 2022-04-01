require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test "show should create with date" do
    show = Show.new
    show.save
    assert_equal 1, Show.count
    assert_equal DateTime.now.change({ hour: 16, minute: 00 }), show.date

    assert_not_nil show
  end

  test "should create 250 tickets when a show is created" do
    show = Show.create
    assert_equal 1, Show.count
    sleep(2)
    assert_equal 250, show.tickets.available.count
    assert_equal 0, show.tickets.sold.count
    assert_not_nil show
  end

  # test "should fail to create more tickets than available" do
  #   show = Show.create
  #   assert_equal 1, Show.count
  #   sleep(2)
  #   assert_equal 250, show.tickets.available.count
  #   assert_equal 0, show.tickets.sold.count
  #   assert_not_nil show

  #   sleep(1)
  #   booker = show.book_tickets(260, "buyer_name", "+919999999999")
  #   assert_nil booker.tickets
  #   assert_not_nil booker.errors
  #   assert_equal "Tickets count invalid", booker.errors[:book_tickets_attributes][0]
  # end

  # test "should book tickets" do
  #   show = Show.create
  #   assert_equal 1, Show.count
  #   assert_not_nil show

  #   sleep(2)
  #   assert_equal 250, show.tickets.available.count
  #   assert_equal 0, show.tickets.sold.count

  #   booker = show.book_tickets(5, "user_name", "+919999999999")

  #   sleep(2)
  #   show.reload
  #   assert_equal 245, show.tickets.available.count
  #   assert_equal 5, show.tickets.sold.count
  #   assert_equal 1, Buyer.count
  #   assert_equal "user_name", Buyer.first.name
  #   assert_equal "+919999999999", Buyer.first.phone
  #   assert_equal 5, Buyer.first.tickets.count
  # end

  # test "should sucessfully book tickets concurrently" do
  #   show = Show.create
  #   assert_equal 1, Show.count
  #   assert_not_nil show

  #   sleep(2)
  #   assert_equal 250, show.tickets.available.count
  #   assert_equal 0, show.tickets.sold.count

  #   list = 1.upto(40)
  #   threads = list.map do |number|
  #     Thread.new do
  #       user_name = "user_name_" + number.to_s
  #       # puts("booking tickets for " + user_name)
  #       booker = show.book_tickets(5, user_name, "+91999999999" + number.to_s)
  #     end
  #   end
  #   threads.each(&:join)
  #   # x = Buyer.all.map do |x| x.name + " " + x.tickets.map do |y| y.ticket_number.to_s + ", " end.join end
  #   # x.each do |x|
  #   #   puts(x)
  #   # end
  #   sleep(5)
  #   show.reload
  #   assert_equal 50, show.tickets.available.count
  #   assert_equal 200, show.tickets.sold.count
  #   assert_equal 40, Buyer.count
  #   buyers = Buyer.all.order(:phone)

  #   buyers.each do |x|
  #     assert_equal 5, x.tickets.count
  #   end
  # end
end
