class SongRequestsMailer < ApplicationMailer
  def send_digest
    @requests = SongRequest.all

    mail(
      from: ENV["MAILER_FROM"],
      to: ENV["MAILER_TO"],
      subject: 'Yacht Or Nyacht Request Line' )
  end
end
