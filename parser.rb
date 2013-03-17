# @cytms

require 'nokogiri'
require 'open-uri'

translator = Hash.new
translator = {'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04', 'May' => '05', 'Jun' => '06', 'Jul' => '07', 'Aug' => '08', 'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12'}
#translator = {'January' => '01', 'Feburay' => '02', 'March' => '03', 'April' => '04', 'May' => '05', 'June' => '06', 'July' => '07', 'August' => '08', 'September' => '09', 'October' => '10', 'November' => '11', 'December' => '12'}
begin
	doc = Nokogiri::HTML(open('http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=RE41066.PN.&OS=PN/RE41066&RS=PN/RE41066'))
	doc.css('center').each do |ref|
		if /Other References/ =~ ref.content then
			other_references = ''
			ref.next_element.css('br').each do |refcon|
				other_references = other_references + refcon.next.content.gsub(' cited by other', '') + "#"
				# insert into `reference` (`patent_id`, `ref_type`, `ref_full`) values (patent_id, '3', refcon)
			end
			#puts other_references.gsub('.#', '#') ==> problems!
		elsif /U.S. Patent Documents/ =~ ref.content then
			references_uspto = ''
			ref.next_element.css('tr td a').each do |record|
				references_uspto = references_uspto + record + ";" 
				date = record.parent.next_element.content.gsub(/\n/, '')
				assignee = record.parent.next_element.next_element.content.gsub(/\n/, '')
				mm, yy = date.split(' ')
				ref_full = record.to_str + ';' + translator[mm[0..2]]  + '-' + yy + ';' + assignee
				# puts full_ref					# => 6701179;03;Martinelli et al.
				# insert into `reference` (`patent_id`, `ref_type`, `ref_full`, `ref_uspto_patent_id`) values (patent_id, '1', full_ref, record) 
			end
			#puts references_uspto
		elsif /Foreign Patent Documents/ =~ ref.content then
			references_foreign = ''
			ref.next_element.css('tr td').each do |record|
				if /^.\d/ =~ record.content then
					references_foreign = references_foreign + record + ";"
					date = record.next_element.next_element.content.gsub(/\n/, '')
					country = record.next_element.next_element.next_element.next_element.content.gsub(/\n/, '')
					mm, yy = date.split('., ')
					ref_full = record.to_str + ';' + translator[mm] + '-' + yy + ';' + country
					# puts ref_full # => 964149;03-1975;CA
					# insert into `reference` (`patent_id`, `ref_type`, `ref_full`, `ref_uspto_patent_id`) values (patent_id, '1', full_ref, record) 
				end
			end
			#puts references_foreign
		end
	end
	# Inventors line
	doc.css('table').each do |field|
		field.css('tr').each do |tuple|
			if /Inventors:/ =~ tuple.content then
				inventors_line = ''
				tuple.css('td b').each do |info|
					inventors_line = inventors_line + info.content.gsub(',', '#') + info.next.content
				end
				#puts inventors_line
			end
		end
	end
rescue => ex
	puts ex
end