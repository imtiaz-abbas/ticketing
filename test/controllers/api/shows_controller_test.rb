require "test_helper"

class Api::ShowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @show = Show.create()
    1.upto(100) do |ticket_number|
      @show.tickets.create(ticket_number: ticket_number)
    end
  end

  test "shows request should succeed" do
    get api_shows_url, headers: {}, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal body["data"][0]["id"], @show.id
  end

  test "show book_tickets should fail with failure when no data given" do
    show = Show.find_by_id(@show.id)
    post "/api/shows/" + @show.id + "/book_tickets", headers: {}, as: :json
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_equal 3, body["data"].count
    assert_equal "ticket_count", body["data"][0]["attribute_name"]
    assert_equal "name", body["data"][1]["attribute_name"]
    assert_equal "phone", body["data"][2]["attribute_name"]
  end

  test "show book_tickets should fail with failure when invalid id given" do
    post "/api/shows/" + "123" + "/book_tickets", params: {
                                                    ticket_count: 3,
                                                    name: "Name",
                                                    phone: "+919999999999",
                                                  }, headers: {}, as: :json
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_equal 1, body["data"].count
    assert_equal "id", body["data"][0]["attribute_name"]
    assert_equal "id Invalid show id", body["data"][0]["messages"][0]
  end

  test "successfully book tickets" do
    post "/api/shows/" + @show.id + "/book_tickets", params: {
                                                       ticket_count: 2,
                                                       name: "Name",
                                                       phone: "+919999999999",
                                                     }, headers: {}, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    tickets = body["data"]
    assert_equal 2, tickets.count
    assert_equal 2, @show.tickets.sold.count
    assert_equal 98, @show.tickets.available.count
    assert_equal 1, @show.tickets.sold.order(:ticket_number).first.ticket_number
    assert_equal 2, @show.tickets.sold.order(:ticket_number).last.ticket_number
  end

  test "should fail with tickets sold out message when trying to book more seats than available" do
    travel 1.day
    show = Show.create
    show.tickets.create(ticket_number: 1)
    post "/api/shows/" + show.id + "/book_tickets", params: {
                                                      ticket_count: 2,
                                                      name: "Name",
                                                      phone: "+919999999999",
                                                    }, headers: {}, as: :json
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_equal 1, body["data"].count
    assert_equal "ticket", body["data"][0]["attribute_name"]
    assert_equal "ticket Tickets sold out", body["data"][0]["messages"][0]
  end

  test "should sucessfully book 1000 tickets using 200 requests concurrently" do
    travel 1.day
    show = Show.create
    assert_not_nil show

    1.upto(1000) do |number|
      show.tickets.create(ticket_number: number)
    end

    assert_equal 1000, show.tickets.available.count
    assert_equal 0, show.tickets.sold.count

    list = 1.upto(200)
    threads = list.map do |number|
      Thread.new do
        user_name = "user_name_" + number.to_s
        phone = "+9199999999" + number.to_s
        post "/api/shows/" + show.id + "/book_tickets", params: {
                                                          ticket_count: 5,
                                                          name: user_name,
                                                          phone: phone,
                                                        }, headers: {}, as: :json
        assert_response :success
        JSON.parse(response.body)
      end
    end
    threads.each(&:join)
    sleep(0.5)
    buyers = Buyer.all.order(:phone)
    # x = buyers.map do |x| x.name + " " + x.phone + " " + x.tickets.map do |y| y.ticket_number.to_s + ", " end.join end
    # x.each do |x|
    #   puts(x)
    # end
    show.reload
    assert_equal 0, show.tickets.available.count
    assert_equal 1000, show.tickets.sold.count
    assert_equal 200, buyers.count

    buyers.each do |x|
      assert_equal 5, x.tickets.count
    end
  end
end
