options
metaserver="bcopxsascsf02.bcocorporate.ad"
metaport=8561
metauser="sasadm@saspw"
metapass="OrigAdm20!";

%let new_hostname = "";   /*colocar o hostname correto aqui. PS: fazer backup do metadados antes*/

libname out "/home/sasdemo";   /*trocar para um diret�rio v�lido no servidor*?

data out.tcpip;
 length uri id HostName Service $255;
 nobj=0;
 n=1;
 
 do while (nobj >= 0);
	nobj=metadata_getnobj("omsobj:TCPIPConnection?@Name='Connection URI'",n,uri);
 
   if (nobj >= 0) then do;
	 rc=metadata_getattr(uri,"Id",id);
	 rc=metadata_getattr(uri,"HostName",HostName);
	 rc=metadata_getattr(uri,"Service",service);
	
	 output;
   end;
 
   n = n + 1;
 end;
 
 drop nobj n rc;
run;

proc print data=out.tcpip;run;

/* executar apenas ap�s listar todos os hostnames e validar a tabela*/
/* por isso o c�digo estar� comentado */

retirar as linhas via GUIDE que n�o precisam ser alteradas, por exemplo DP - * 

PAra o SAS_Theme alterar via SMC com os servi�os do SAS ativos.
/*

%let omsobj_tcp = "omsobj:TCPIPConnection?@Id=";
	
	data _null;
		set out.tcpip;
	
		url_final = &omsobj_tcp. || "'" || trim(id) || "'";
				
		rc=metadata_setattr(url_final,
					        "HostName",
                            &new_hostname);
			
	run;
	
*/
 