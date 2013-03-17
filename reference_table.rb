# reference_table.rb
#def USPTOtoReferenceTable (data)
#	puts data
#end

#def ForeigntoReferenceTable (data)

#end

data1 = "1576781;1735726;2407845;2650588;"
data2 = "964149;3042343;3831278;"
data3 = "\"Prestige Cervical Disc System Surgical Technique\", 12 pgs, Author/Date?#Adams et al., \"Orientation Aid for Head and Neck Surgeons,\" Innov. Tech. Biol. Med., vol. 13, No. 4, 1992, pp. 409-424.#"

data1.split(";").each do |id|
	puts id
end

puts

data2.split(";").each do |id|
	puts id
end

data3.split("#").each do |topic|
	puts topic
end