# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "thread/pool"

Ticket.all.map do |x| x.delete end
Buyer.all.map do |x| x.delete end
Show.all.map do |x| x.delete end
show = Show.create

sleep(6)

# pool = Thread.pool(9)

# 1.upto(50).map do |number|
#   pool.process {
#     name = "user_name_" + number.to_s
#     phone = "+9199999999" + number.to_s
#     puts "booker starting " + number.to_s
#     booker = Show::TicketBooker.new
#     booker.book_tickets_attributes = { id: show.id, ticket_count: 5, name: name, phone: phone }
#     if booker.book
#       puts "booking done for number " + number.to_s
#     else
#       puts "booking failed for number " + number.to_s
#       puts booker.errors.as_pretty_json
#     end
#     booker
#   }
# end

# pool.shutdown
