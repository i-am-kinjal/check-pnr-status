require 'mechanize'
mechanize = Mechanize.new
mechanize.history_added = Proc.new { sleep 4 }
mechanize.follow_meta_refresh = true 
mechanize.verify_mode = OpenSSL::SSL::VERIFY_NONE
puts ""
print "Enter PNR Number: "
pnr_num = gets.chomp.to_i
begin
  page = mechanize.get("http://www.indianrail.gov.in/pnr_Enq.html")
  page.forms[0]['lccp_pnrno1'] = pnr_num
  info = page.forms[0].submit.search(".table_border").search("td")
  info = info[1..info.count-4]
  puts ""
  for i in (0..7)
    puts "#{info[i].text} : #{info[i+8].text}"
  end
  puts "#{info[info.count-2].text} : #{info.last.text}"
  puts ""
  info = info[19..info.count-3]
  while info.count != 0
    puts "#{info[0].text} status: #{info[2].text.strip} (current)"
    info.delete(info.first)
    info.delete(info.first)
    info.delete(info.first)
  end
  puts ""
rescue Exception => e
  puts "Enquiry failed. Please check your PNR number."
end
