namespace :cron_jobs do
  desc "Schedules cron jobs for various tasks"

  task schedule_show_create_job: :environment do
    CreateShowJob.setup_schedule
  end
end
