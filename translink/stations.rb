#Script to pull stations from translink

require 'rubygems'
require 'rest_client'
#require 'hpricot'
require 'nokogiri'

RestClient.log = 'RC.log'

#response = RestClient.get 'http://jp.translink.com.au/TransLinkstationTimetable.asp'
#f = File.open('stations.html', 'w')
#f.syswrite(response)

# page = open('stations.html') { |f| Hpricot(f)}

# page.search("//select[@name='FromSuburb']/option").each do |o|
#   puts "#{o.inner_html.strip}:#{o.get_attribute('value').strip}"
# end

doc = Nokogiri::HTML(open('stations.html'))

doc.xpath("//select[@name='FromSuburb']/option").each do |o|
	puts "#{o.content.strip}:#{o[:value].strip}"
end