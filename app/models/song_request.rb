class SongRequest < ActiveRecord::Base
  scope :undigested, -> { where(digested: false) }

  after_create :send_mailer

  private

  def send_mailer
    SongRequestsMailer.send_request(self).deliver_later
  end
end
