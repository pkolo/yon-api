class SongRequestsMailer < ApplicationMailer
  def send_digest(requests)
    @requests = JSON.parse(requests)

    mail(
      from: ENV["MAILER_FROM"],
      to: ENV["MAILER_TO"],
      subject: "Yacht Or Nyacht Request Digest #{Time.current.strftime('%m/%d/%Y')}" )
  end

  def send_request(request)
    @request = request

    mail(
      from: ENV["MAILER_FROM"],
      to: ENV["MAILER_TO"],
      subject: "'#{@request.title}' by #{@request.artist}" )
  end
end
