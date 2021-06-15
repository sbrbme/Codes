filename f "/sasdata/DeploymentRegistry_bcopxsascsr03.txt";

data import;
  length linha $400. nt 8.;
  infile f lrecl=400 pad ; 
  input linha $400.; 
   
  excluir=length(linha);

  if linha ne "SAS Installed Software And Components";
  if excluir ne 1; 
  if compress(substr(linha,1,7)) ne "SASHOME";

  coluna=scan(linha,1,":");
  registro=scan(linha,2,":");

   retain nt; 
	if trim(coluna) eq "Hot Fix Entry" then do;
	  nt + 1;
      coluna=trim(coluna)!!"("!!put(nt,$2.)!!")";
	end;
	else nt=0;
 
  drop excluir nt;
  
run;



%macro loop;

data _null_;
  set import;

  retain nlooping;
  if coluna="-------------------------------------------------------------------------------" then do;
      nlooping+1;
     call symput('nloop',nlooping);
  end;
run;

%do n=1 %to &nloop;
	%let delimiter="-------------------------------------------------------------------------------";
	data import inter;
	   	set import;
   
 	  if coluna eq &delimiter then n+1;
	  	else if n = 0 then output inter; 

   	  if n >= 1 then do;
         if n = 1 and coluna eq &delimiter then delete; else output import;
      end;   
        drop linha n ;
    run;


  PROC TRANSPOSE DATA=inter 
	  OUT=tranpInter_&n
	  NAME=Source
	  LABEL=Label
     ;
	   ID coluna;
	   VAR registro;

  RUN;

  /*
  
  %if &n=1 %then %do;
    data tabelafinal;
	 set tranpInter;
	run;
   
  %end;
  %else %do;
     proc append data=tabelaFinal base=tranpInter force; run;

	 data tabelafinal;
	 set tranpInter;
	run;

    proc delete data=tranpInter; run;

  %end;

  */

%end;

  data tabelafinal;
     set tranpInter_1;
  run;

  %do n=2 %to &nloop;
         proc append data=tabelaFinal base=tranpInter_&n  force; run;

         data tabelafinal;
     	    set tranpInter_&n;
  		 run;

  %end;




%mend;
%loop;






