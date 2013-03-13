def getReferences(html)
	doc = Nokogiri::HTML(html)
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
end

def getInventer(html)
	doc = Nokogiri::HTML(html)
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
end