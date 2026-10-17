    /*
    Naslov: Skripta za brisanje procedura stupaca tablica silver sloja
    Autor: Marko Vresk 
    Datum: 01.10.2026.
    Opis: Ova skripta briše sve procedure za provjeru stupaca tablica silver sloja u SQL Serveru.
    Upozorenje: Brisanjem procedura, gube se sve funkcionalnosti provjere podataka u tablicama silver sloja. Prije brisanja, preporučuje se izraditi sigurnosnu kopiju procedura ili ih spremiti na sigurno mjesto.
    */
    DROP PROCEDURE silver.provjera_referencijalnog_integriteta
	DROP PROCEDURE silver.provjera_valjanosti_start_i_end_datuma
	DROP PROCEDURE silver.provjera_negativnosti_vrijednosti
	DROP PROCEDURE silver.provjera_duplikata
	DROP PROCEDURE silver.provjera_null_vrijednosti
	DROP PROCEDURE silver.provjera_valjanosti_datuma
	DROP PROCEDURE silver.provjera_razmaka_u_nazivima
	DROP PROCEDURE silver.provjera_distinktnih_naziva
	DROP PROCEDURE silver.provjera_max10_vrijednosti
	DROP PROCEDURE silver.provjera_min10_vrijednosti