desc "Sends song request digest"
task :send_digest => :environment do
  puts "Sending digest..."
  requests = SongRequest.undigested

  if requests.any?
    SongRequestsMailer.send_digest(requests.to_json).deliver_later

    requests.each { |request| request.update(digested: true) }
    puts "sent."
  else
    puts "no new song requests."
  end
end
