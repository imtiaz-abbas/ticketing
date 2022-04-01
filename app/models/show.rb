class Show < ApplicationRecord
  has_many :tickets
  enum status: [:as_per_schedule, :cancelled], _default: "as_per_schedule"

  before_create :setup_show_date
  after_create_commit :enqueue_ticket_creation_jobs

  def book_tickets_exp
    BookTicketsJob.perform_later(self.id, 5, (0...5).map { (65 + rand(26)).chr }.join, (0...9).map { (rand(10)) }.join)
  end

  protected

  def setup_show_date
    self.date = DateTime.now.change({ hour: 16, minute: 00 })
  end

  def enqueue_ticket_creation_jobs
    1.upto(250) do |ticket_number|
      TicketGenerationJob.perform_later(id, ticket_number)
    end
  end
end
