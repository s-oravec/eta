create or replace package eta_impl as

    DAYS_MAX      constant pls_integer := 9;
    FRACTIONS_MAX constant pls_integer := 6;

    subtype typ_EtaInterval is interval day(9) to second(6);

    procedure setTotalWork(a_totalwork in pls_integer);

    function get(a_sofar in pls_integer) return typ_EtaInterval;

    function get(
        a_startedAt in timestamp,
        a_totalWork in pls_integer,
        a_sofar     in pls_integer
    ) return typ_EtaInterval;

    function getFormatted
    (
        a_sofar     in pls_integer,
        a_days      in pls_integer,
        a_fractions in pls_integer
    ) return varchar2;

    function getFormatted
    (
        a_startedAt in timestamp,
        a_totalWork in pls_integer,
        a_sofar     in pls_integer,
        a_days      in pls_integer,
        a_fractions in pls_integer
    ) return varchar2;

end;
/