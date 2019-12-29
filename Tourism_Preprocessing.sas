
data cleaned_tourism;
	length Country_Name $300 Tourism_Type $20;
	retain Country_Name "" Tourism_Type "";
	set cr.tourism(drop=_1995-_2013);
	if A ne . then  Country_Name=Country;
	if lowcase(Country) = "inbound tourism" then Tourism_Type="Inbound tourism";
		else if lowcase(Country) = "outbound tourism" then Tourism_Type="Outbound tourism";
	if Country_Name ne Country and Country ne Tourism_Type;
	series=upcase(series);
	if series=".." then Series="";
	ConversionType=scan(Country,-1," ");
	if _2014=".." then _2014=".";
	if ConversionType='Mn' then do;
		if _2014 ne "." then Y2014 = input(_2014,16.) * 1000000;
			else Y2014=.;
		Category=cat(scan(country,1,'-','r'),' - US$');
	end;
	else if ConversionType='Thousands' then do;
		if _2014 ne "." then Y2014 = input(_2014,16.) * 1000;
			else Y2014=.;
		Category=scan(country,1,'-','r');
	end;
	format y2014 comma25.; 
 	drop A ConversionType Country _2014; 
run;

proc freq data=cleaned_tourism;
	tables country Category;
run;

proc means data=cleaned_tourism min max mean n maxdec=0;
	var Y2014 Tourism_Type;
run;