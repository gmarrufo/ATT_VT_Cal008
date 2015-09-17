load data 
infile cal009_marker_matrix.dat
append into table cal009_marker_matrix
fields terminated by '|'
(marker, description)
