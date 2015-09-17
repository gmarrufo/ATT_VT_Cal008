load data
infile cal009_zipcode_mapping.dat
append
into table cal009_zipcode_mapping
fields terminated by ';'
(zipcode,location,audio_index)
