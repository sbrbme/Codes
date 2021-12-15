    
options fullstimer;
	
     data xx_random;
        do n = 1 to 348000000;  /* 12GB */
           aleat1 = ceil(ranuni*10000);
           aleat2 = ceil(ranuni*100);
           if ranuni< .5 then ind = 'S'; else ind = 'N';
             output;
           end;
      run;


	  /* Testes */
      proc sort data=xx_random;
        by aleat1;
      run;


      proc freq data=xx_random;
        tables ind;
      run;


	  proc sql;
	    create table xx_random2 as 
		  select * from xx_random;
	  quit;


      data xx_random_bkp;
        set xx_random;
          nalt = _N_;
      run;


      /* Delete */
      proc delete data=xx_random; run;

      proc delete data=xx_random_bkp; run;

      proc delete data=xx_random2; run;
	  