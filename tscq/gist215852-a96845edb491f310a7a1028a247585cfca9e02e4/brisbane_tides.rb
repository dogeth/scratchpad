#Script to pull tide information from bom and output in ical format

require 'rubygems'
require 'rest_client'
require 'hpricot'
require 'icalendar'

include Icalendar

def isNumeric(s)
  Float(s) != nil rescue false
end

@timezone_offset = 10
searchdate = Date.new(2010,1,1)
enddate = Date.new(2011,1,1)

RestClient.log = 'RC.log'

cal_lowtide = Calendar.new
cal_hightide = Calendar.new

while searchdate < enddate
  response = RestClient.post 'http://www.bom.gov.au/cgi-bin/oceanography/tides/tide_predications.cgi', :'Submit.x' => '36', :'Submit.y' => '9', :dates => "#{searchdate.strftime('%d')}", :location => 'qld_59980', :months => "#{searchdate.strftime('%b')}", :tide_hiddenField => 'Queensland', :years => "#{searchdate.year}"

  page = Hpricot(response)
  colindex = 0
  rowindex = 0
  page.search("html/body/table[3]/tr/td/table/tr").each do |row|
    rowindex+=1
    next if rowindex < 3 #ignore first two rows 

    istime = true

    row.search("//th").each do |data|

      if (istime)
        @tidetime = data.html.strip
        @tidedate = searchdate + colindex

        colindex+=1
        colindex = 0 if colindex >= 7 #7 columns of data, cycling through each one
      else
        if isNumeric(@tidetime) && @tidedate <= enddate
          eventdate = DateTime.civil(@tidedate.year, @tidedate.month, @tidedate.day, @tidetime[0,2].to_i, @tidetime[2,2].to_i, 0, Rational(@timezone_offset, 24))

          lt = data.search("//i")
          if lt.any? 
            event = cal_lowtide.event  # This automatically adds the event to the calendar
            event.summary = "LT #{lt.html.strip}"
          else
            ht = data.search("//font")
            event = cal_hightide.even
            event.summary = "HT #{ht.html.strip}"
          end
          event.start       = eventdate
          event.end         = eventdate
          event.location    = "Brisbane Bar"
        end
      end
      istime = !istime
    end
  end
  searchdate+=7 #7 days of tide information comes back from bom
end

f = File.open('lowtide.ics', 'w')
f.syswrite(cal_lowtide.to_ical)

f = File.open('hightide.ics', 'w')
f.syswrite(cal_hightide.to_ical)
