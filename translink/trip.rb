#Script to pull trip details from translink

require 'rubygems'
require 'rest_client'
require 'nokogiri'

tripkey = '263563'
journeydate = '19/4/2010'

# response = RestClient.get "http://jp.translink.com.au/TransLinkTripTimetable.asp?TripKey=#{tripkey}&Date=#{journeydate}"
# f = File.open('trip.html', 'w')
# f.syswrite(response)

doc = Nokogiri::HTML(open('trip.html'))

station = ''
departs_row = false

doc.css("tr.TimetableDetails").each do |o|
  
  if departs_row
    departs_row = false
    time = o.xpath("td[@align='right']").first.content.strip
    puts "#{station} departs at #{time}"
  else
    data = o.css('b')
    station = data[0].content.strip
    if data.length == 2
      time = data[1].content.strip
      puts "#{station} at #{time}"
    else
      time = o.xpath("td[@align='right']").first.content.strip
      puts "#{station} arrives at #{time}"
      departs_row = true
    end
  end
  
end

