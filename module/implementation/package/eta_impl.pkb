create or replace package body eta_impl as

    g_totalWork pls_integer;
    g_startedAt timestamp;

    ----------------------------------------------------------------------------
    procedure setTotalWork(a_totalWork in pls_integer) is
    begin
        g_totalWork := nvl(a_totalWork, 0);
        g_startedAt := systimestamp;
    end;

    ----------------------------------------------------------------------------
    function get_impl(
        a_startedAt in timestamp,
        a_totalWork in pls_integer,
        a_sofar     in pls_integer
    ) return typ_EtaInterval is
    begin
        if a_startedAt is null or
           nvl(a_sofar, 0) <= 1 or
           nvl(a_totalWork, 0) = 0 or
           a_totalWork < a_sofar
        then
            return null;
        else
            return (systimestamp - a_startedAt) / (a_sofar - 1) * (a_totalWork - a_sofar + 1);
        end if;
    end;

    ----------------------------------------------------------------------------
    function get(a_sofar in pls_integer) return typ_EtaInterval is
    begin
        return get_impl(g_startedAt, g_totalWork, a_sofar);
    end;

    ----------------------------------------------------------------------------
    function get(
        a_startedAt in timestamp,
        a_totalWork in pls_integer,
        a_sofar     in pls_integer
    ) return typ_EtaInterval is
    begin
        return get_impl(a_startedAt, a_totalWork, a_sofar);
    end;

    ----------------------------------------------------------------------------
    function formatEta
    (
        a_eta       in typ_EtaInterval,
        a_days      in pls_integer,
        a_fractions in pls_integer
    ) return varchar2 is
    begin
        if a_eta is null then
            return 'N/A';
        else
            declare
                l_decimal        pls_integer;
                lc_time constant pls_integer := 8;
            begin
                l_decimal := case a_fractions when 0 then 0 else 1 end;
                if a_days = 0 then
                    return substr(to_char(a_eta), 12, lc_time + l_decimal + a_fractions);
                else
                    return substr(to_char(a_eta), 2 + (eta_impl.DAYS_MAX - a_days), a_days + 1 + lc_time + l_decimal + a_fractions);
                end if;
             end;
        end if;
    end;

    ----------------------------------------------------------------------------
    function getFormatted
    (
        a_sofar     in pls_integer,
        a_days      in pls_integer,
        a_fractions in pls_integer
    ) return varchar2 is
    begin
        return formatEta(get(a_sofar), a_days, a_fractions);
    end;

    ----------------------------------------------------------------------------
    function getFormatted
    (
        a_startedAt in timestamp,
        a_totalWork in pls_integer,
        a_sofar     in pls_integer,
        a_days      in pls_integer,
        a_fractions in pls_integer
    ) return varchar2 is
    begin
        return formatEta(get(a_startedAt, a_totalWork, a_sofar), a_days, a_fractions);
    end;

end;
/