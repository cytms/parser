# inventer_table.rb
# inventor_line = "Martinelli; Michael A. (Winchester, MA)#Haase; Wayne C. (Sterling, MA)#"
def patentToInventor(patent_id, inventor_line)
	inventor_line.split(')#').each do |inventor_info|
		inventor, inventor_loc = inventor_info.split(' (')
		puts inventor, inventor_loc
		# insert into inventor (`patent_id`, `inventor_name`, `inventor_location`) values (patent_id, inventor, inventor_loc)
	end
end