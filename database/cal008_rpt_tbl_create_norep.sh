pw=`/usr/local/vtone/plat/orautils/bin/wevscust 2>/dev/null`
if [ $? -ne 0 ]
then
      # Failed ... set to default
      pw=wevscust
fi
sqlplus wevscust/$pw@wevs <<!EOF

-- ********************************************************
-- * call activity detail table
-- ********************************************************

create table wevscust.cal008_call_activity (
    call_id           varchar2(64) not null,
    start_time        date not null,	-- call end time
    end_time          date not null,	-- call start time
    ani 	      varchar2(15),	--
    dnis              varchar2(15),	--
    language          varchar2(25)  not null, -- ENGLISH,CANTONESE,VIETNAMESE,HMONG,SPANISH 
    zip_locs_string   varchar2(200) not null, -- zip1:loc1,loc2,loc3,loc4,loc5|zip2:loc1,loc2|zip3:loc1
					-- 4 digit loc ID no leading zero, 5 digit zip code
    last_marker       varchar2(15) not null,	-- last marker pegged on call
    marker_string     varchar2(4000) not null,	-- markers hit by call, format |<Marker1>:<count>|<Marker2>:<count>|<Marker3>:<count>|
    termination_type  varchar2(2) not null,	-- type of call termination
					-- a = application disconnect
					-- c = caller hang up
					-- t = call transfer
    transfer_rtn  varchar2(15),		-- transfer number 
--
    constraint pk_cal008_call_activity primary key (call_id, end_time)
  );
  grant all on cal008_call_activity to wevsplat;
  commit;

  
!EOF
