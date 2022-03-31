# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

KnowmanShow.all.map do |x| x.delete end
KnowmanShow.create
Ticket.sold.map do |x| x.update(status: "available", buyer: nil) end
Buyer.all.map do |x| x.delete end
Buyer.all.map do |x| x.name + " " + x.tickets.map do |y| y.ticket_number.to_s + ", " end.join end
