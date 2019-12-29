proc format;
	value contIDs
		1 = "North America"
		2 = "South America"
		3 = "Europe"
		4 = "Africa"
		5 = "Asia"
		6 = "Oceania"
		7 = "Antartica";
run;

proc sort data=cr.country_info(rename=(Country=Country_Name))
			out=country_sorted;
	by country_name;
run;

data final_tourism;
	merge cleaned_tourism(in=t) Country_Sorted(in=c);
	by country_name;
	if t=1 and c=1 then output Final_Tourism;
	format continent contIDs;
run;

proc freq data=final_tourism nlevels;
	tables category series Tourism_Type Continent /nocum nopercent;
run;

proc means data=final_tourism min max mean maxdec=0;
	var Y2014;
run;

proc means data=final_tourism mean min max maxdec=0;	
	var y2014;
	class Continent;
	where Category="Arrivals";
run;

proc means data=final_tourism mean maxdec=0;	
	var y2014;
	where lowcase(Category) contains "tourism expenditure in other countries";
run;