class KnowhereShow < ApplicationRecord
  enum status: [:scheduled, :cancelled], _default: "scheduled"

  before_create :setup_show_date
  after_create_commmit :enqueue_ticket_creation_jobs

  def setup_show_date
    self.date = DateTime.now.change({ hour: 16, minute: 00 })
  end

  def enqueue_ticket_creation_jobs
    # todo: create 250 jobs to create tickets
  end
end
