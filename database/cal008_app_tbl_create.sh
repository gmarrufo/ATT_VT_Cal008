#!/bin/ksh

export ORACLE_HOME=/oracle
export ORACLE_SID=WEVS
export PATH=$PATH:$ORACLE_HOME/lib:$ORACLE_HOME/bin

# Using orautil to find the password
pw=`/usr/local/vtone/plat/orautils/bin/wevscust 2>/dev/null`
if [ $? -ne 0 ]
then
        # Failed ... set to default
        pw=wevscust
fi

sqlplus wevscust/$pw@WEVS <<!EOF
spool /var/tmp/cal008_create.out
set define off

-- ********************************************************
-- * cal008_zipcode_locations table 
-- ********************************************************

  create table wevscust.cal008_zipcode_locations (
        zipcode varchar2(5) not null
           CHECK (REGEXP_LIKE(zipcode, '^[[:digit:]]{5}$')),
        location_1 varchar2(4) 
           CHECK (REGEXP_LIKE(location_1, '^[[:digit:]]{4}$')),
        location_2 varchar2(4)
           CHECK (REGEXP_LIKE(location_2, '^[[:digit:]]{4}$')),
        location_3 varchar2(4)
           CHECK (REGEXP_LIKE(location_3, '^[[:digit:]]{4}$')),
        location_4 varchar2(4)
           CHECK (REGEXP_LIKE(location_4, '^[[:digit:]]{4}$')),
        location_5 varchar2(4)
           CHECK (REGEXP_LIKE(location_5, '^[[:digit:]]{4}$')),
--
        constraint cal008_zipcode_locations_key primary key (zipcode)
  );

  grant all on cal008_zipcode_locations to wevsplat; 
  commit;

!sqlldr userid=wevscust/$pw@wevs control=cal008_zipcode_locations.ctl

-- ********************************************************
-- * cal008_location_phrase table
-- ********************************************************

  create table wevscust.cal008_location_phrase (
        location varchar2(4) not null
           CHECK (REGEXP_LIKE(location, '^[[:digit:]]{4}$')),
        phrase_number varchar2(4) not null
           CHECK (REGEXP_LIKE(phrase_number, '^[[:digit:]]{4}$')),
        phrase_text varchar2(255) not null,
--
        constraint cal008_location_phrase_key primary key (location)
  );

  grant all on cal008_location_phrase to wevsplat;
  commit;

!sqlldr userid=wevscust/$pw@wevs control=cal008_location_phrase.ctl

spool off
!EOF
