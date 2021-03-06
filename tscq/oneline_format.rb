#Script to change the TSCQ calander into a one line format

require 'rubygems'
require 'bundler/setup'
require 'icalendar'
require 'active_support/all'

include Icalendar

timezone_offset = 10

# Open a file or pass a string to the parser
cal_file = File.open('TSCQ.ics')
start_from_date = Date.new(2012,1,1)


# Parser returns an array of calendars because a single file
# can have multiple calendars.
cals = Icalendar.parse(cal_file)
cal = cals.first

File.open('TSCQ.txt','w') do |f|

  cal.events.sort_by { |e| e.dtstart}.each do |e|
    #Must be a better way to do this... I had to fool around with time zone info.  Also, full day events had a finish time of midnight (needed to bring that back into today)
    
    dtstart = DateTime.parse(e.dtstart.to_s) 
  
    if (dtstart > start_from_date)

      dtend = DateTime.parse(e.dtend.to_s) 
      dtstart += 10.hours if (dtstart.hour > 0 || dtend.hour > 0)
      dtend += dtend.hour > 0 ? 10.hours : -1.second

      first_date = true
      while Date.parse(dtstart.strftime('%Y/%m/%d')) <= Date.parse(dtend.strftime('%Y/%m/%d'))
        display_time = (first_date && dtstart.hour > 0) ? "#{dtstart.strftime('%H:%M')}" : "     "

        f.puts "#{dtstart.strftime('%d/%m/%Y')} #{display_time} #{e.summary}"
        dtstart+=1
        first_date = false
      end  
    end

  end
 
end
