include ../../tarrules.mk
include ../../rpmrules.mk

:ALL: cal008CS.tar - rpm-cs  
ALL: cal008CS.tar - rpm-cs - cal008DB.tar - rpm-ds

cal008DB.tar :TAR: database rpm/ds/postinstall 

rpm-ds :RPM: rpm/ds/cal008.spec cal008DB.tar

cal008CS.tar :TAR: cal008.war \
	rpm/cs/postinstall

rpm-cs :RPM: rpm/cs/cal008.spec cal008CS.tar 

cal008RS.tar :TAR: rpm/rs/postinstall 

rpm-rs :RPM: rpm/rs/cal008.spec \
        cal008RS.tar 
