# @cytms

require 'nokogiri'
require 'open-uri'

begin
	doc = Nokogiri::HTML(open('http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=RE41066.PN.&OS=PN/RE41066&RS=PN/RE41066'))
	doc.css('center').each do |ref|
		if /Other References/ =~ ref.content then
			other_references = ''
			ref.next_element.css('br').each do |refcon|
				other_references = other_references + refcon.next.content.gsub(' cited by other', '') + "#"
			end
			#puts other_references.gsub('.#', '#') ==> problems!
		elsif /U.S. Patent Documents/ =~ ref.content then
			references_uspto = ''
			ref.next_element.css('tr td a').each do |record|
				references_uspto = references_uspto + record + ";" 
			end
			#puts references_uspto
		elsif /Foreign Patent Documents/ =~ ref.content then
			references_foreign = ''
			ref.next_element.css('tr td').each do |record|
				if /^.\d/ =~ record.content then
					references_foreign = references_foreign + record + ";" 
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