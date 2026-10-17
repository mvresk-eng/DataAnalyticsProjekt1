	/*
    Naslov: Brisanje procedura za provjeru stupaca gold sloja
    Autor: Marko Vresk
    Datum: 17.10.2026.
    Opis: Ova skripta briše sve procedure za provjeru stupaca tablica gold sloja u SQL Serveru.
    Upozorenje: Brisanjem procedura, gube se sve funkcionalnosti provjere podataka u tablicama gold sloja. Prije brisanja, preporučuje se izraditi sigurnosnu kopiju procedura ili ih spremiti na sigurno mjesto.
    */
    DROP PROCEDURE gold.provjera_referencijalnog_integriteta
	DROP PROCEDURE gold.provjera_valjanosti_start_i_end_datuma
	DROP PROCEDURE gold.provjera_negativnosti_vrijednosti
	DROP PROCEDURE gold.provjera_duplikata
	DROP PROCEDURE gold.provjera_null_vrijednosti
	DROP PROCEDURE gold.provjera_valjanosti_datuma
	DROP PROCEDURE gold.provjera_razmaka_u_nazivima
	DROP PROCEDURE gold.provjera_distinktnih_naziva