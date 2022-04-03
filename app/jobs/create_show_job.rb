class CreateShowJob < ApplicationJob
  queue_as :critical
  sidekiq_options retry: true, queue: :critical

  def perform
    Show.create
  end

  def self.setup_schedule
    job_name = name
    job = Sidekiq::Cron::Job.find(job_name)
    if job.present?
      logger.info "Destroying cron job #{job_name}"
      job.destroy
    end
    job_class = name
    # every day at 9AM
    created_job = Sidekiq::Cron::Job.create(name: job_name, cron: "0 9 * * * Asia/Kolkata", class: job_class)
    logger.info "Scheduled cron job #{created_job.as_json}"
  end
end
