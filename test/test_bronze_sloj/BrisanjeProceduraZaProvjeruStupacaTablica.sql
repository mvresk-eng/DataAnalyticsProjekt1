    /*
    Naslov: Skripta za brisanje procedura stupaca tablica bronze sloja
    Autor: Marko Vresk 
    Datum: 27.09.2026.
    Opis: Ova skripta briše sve procedure za provjeru stupaca tablica bronze sloja u SQL Serveru.
    Upozorenje: Brisanjem procedura, gube se sve funkcionalnosti provjere podataka u tablicama bronze sloja. Prije brisanja, preporučuje se izraditi sigurnosnu kopiju procedura ili ih spremiti na sigurno mjesto.
    */
    
    DROP PROCEDURE bronze.provjera_referencijalnog_integriteta
	DROP PROCEDURE bronze.provjera_valjanosti_start_i_end_datuma
	DROP PROCEDURE bronze.provjera_negativnosti_vrijednosti
	DROP PROCEDURE bronze.provjera_duplikata
	DROP PROCEDURE bronze.provjera_null_vrijednosti
	DROP PROCEDURE bronze.provjera_valjanosti_datuma
	DROP PROCEDURE bronze.provjera_razmaka_u_nazivima
	DROP PROCEDURE bronze.provjera_distinktnih_naziva
	DROP PROCEDURE bronze.provjera_max10_vrijednosti
	DROP PROCEDURE bronze.provjera_min10_vrijednosti