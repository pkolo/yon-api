class SongRequestsMailerJob < ApplicationJob
  queue_as :mailers

  def perform(*args)
    SongRequestsMailer.send_digest.deliver
  end
end
