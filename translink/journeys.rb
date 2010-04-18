#Script to pull journeys from translink

require 'rubygems'
require 'rest_client'
require 'nokogiri'


origin = 'CENTRAL+RAILWAY+STATION'
destination = 'COORPAROO+RAILWAY+STATION'
journeydate = '19/4/2010'

# response = RestClient.get "http://jp.translink.com.au/TransLinkFromToTimetable.asp?Origin=#{origin}&Destination=#{destination}&Date=#{journeydate}"
# f = File.open('journeys.html', 'w')
# f.syswrite(response)


doc = Nokogiri::HTML(open('journeys.html'))

doc.css("th.TimetableRouteNumber a").each do |o|
  if o[:href] =~ /TripKey=(.+)&Date=(.+)&Route=(.+)&Origin=(.+)&Destination=(.+)&ArriveTime=(.+)&DepartTime=(.+)/
    puts "#{$1} #{$2} #{$3} #{$4} #{$5} #{$6} #{$7}"
  end
end
