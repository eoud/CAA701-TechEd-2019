*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_utils definition final.

  public section.
    class-methods:
      random
        importing
          iv_min type i default 1
          iv_max type i default 100
        returning
          value(rv_value) type int8.

endclass.
class lcl_utils implementation.

  method random.
    rv_value = cl_abap_random_int=>create( seed = cl_abap_random=>seed( ) min  = iv_min  max  = iv_max )->get_next( ).
  endmethod.

endclass.

class lcl_airline definition final.

  public section.

    types:
      begin of ty_connection,
        id       type zcaa701_sflight-connid,
        from     type zcaa701_airportid,
        to       type zcaa701_airportid,
        plane    type zcaa701_planeid,
        start    type t,
        duration type i,
        pets     type i,
      end of ty_connection,

      tt_connections type standard table of ty_connection with default key.

    methods:
      constructor
        importing
          !iv_id type zcaa701_carrid.

    data:
      mt_connections type tt_connections read-only.

  private section.

    data:
      _mv_id type zcaa701_carrid.

endclass.
class lcl_airline implementation.

  method constructor.
    _mv_id = iv_id.

    case _mv_id.
      when 'BA'.
        mt_connections = value #(
          ( id = '224'  from = 'MSY' to = 'LHR' plane = '787-900' start = '2135' duration = 500 )
          ( id = '2262' from = 'KIN' to = 'LGW' plane = '777-200' start = '1745' duration = 510 )
          ( id = '2262' from = 'KIN' to = 'LGW' plane = '777-200' start = '1745' duration = 510 )
          ( id = '38'   from = 'PEK' to = 'LHR' plane = '777-300' start = '1140' duration = 600 )
          ( id = '38'   from = 'PEK' to = 'LHR' plane = '777-300' start = '1140' duration = 600 )
          ( id = '248'  from = 'GIG' to = 'LHR' plane = '787-800' start = '2150' duration = 645 )
          ( id = '198'  from = 'BOM' to = 'LHR' plane = '777-200' start = '1310' duration = 541 )
          ( id = '175'  from = 'LHR' to = 'JFK' plane = '747-400' start = '0935' duration = 420 )
          ( id = '268'  from = 'LAX' to = 'LHR' plane = '380-800' start = '2135' duration = 652 )
          ( id = '800'  from = 'LHR' to = 'KEF' plane = '320-200' start = '0740' duration = 158 )
          ( id = '154'  from = 'CAI' to = 'LHR' plane = '340-300' start = '0800' duration = 275 )
          ( id = '2694' from = 'LGW' to = 'FAO' plane = '319-100' start = '0840' duration = 143 )
        ).

      when 'IB'.
        mt_connections = value #(
          ( id = '615'  from = 'FRA' to = 'MAD' plane = '321-200' start = '1210' duration = 170 )
          ( id = '1546' from = 'MAD' to = 'BCN' plane = '321-200' start = '1545' duration = 80  )
          ( id = '8619' from = 'FRA' to = 'MAD' plane = '321-200' start = '0630' duration = 170 )
          ( id = '1130' from = 'MAD' to = 'BCN' plane = '321-200' start = '1130' duration = 80  )
          ( id = '8615' from = 'FRA' to = 'MAD' plane = '321-200' start = '1210' duration = 170 )
          ( id = '1730' from = 'MAD' to = 'BCN' plane = '321-200' start = '1730' duration = 80  )
          ( id = '1846' from = 'MAD' to = 'BCN' plane = '321-200' start = '1845' duration = 80  )

        ).

      when 'FR'.
        mt_connections = value #(
          ( id = '1680'  from = 'FRA' to = 'BCN' plane = '737-800' start = '1755' duration = 150 )
          ( id = '1681'  from = 'BCN' to = 'FRA' plane = '737-800' start = '1850' duration = 150 )
        ).

      when 'AC'.
        mt_connections = value #(
          ( id = '807'  from = 'CDG' to = 'YVR' plane = '787-800' start = '0925' duration = 550 )
          ( id = '842'  from = 'YYZ' to = 'DUB' plane = '330-300' start = '2305' duration = 365 )
          ( id = '890'  from = 'YYZ' to = 'FCO' plane = '777-300' start = '2100' duration = 460 )
          ( id = '809'  from = 'CMN' to = 'YUL' plane = '330-300' start = '0910' duration = 380 )
          ( id = '2402' from = 'YUL' to = 'BCN' plane = '330-200' start = '2255' duration = 400 )
          ( id = '873'  from = 'FRA' to = 'YYZ' plane = '777-300' start = '0920' duration = 480 )
          ( id = '90'   from = 'YYZ' to = 'GRU' plane = '787-900' start = '1145' duration = 560 )
          ( id = '92'   from = 'YYZ' to = 'SCL' plane = '787-900' start = '2140' duration = 555 )
          ( id = '786'  from = 'LAX' to = 'YYZ' plane = '767-300' start = '1205' duration = 246 )
        ).

      when 'AA'.
        mt_connections = value #(
          ( id = '719' from = 'FCO' to = 'PHL' plane = '330-300' start = '1150' duration = 540 )
          ( id = '41'  from = 'BCN' to = 'ORD' plane = '787-800' start = '1530' duration = 540 )
          ( id = '151' from = 'MAD' to = 'DFW' plane = '787-900' start = '1720' duration = 600 )
          ( id = '107' from = 'LHR' to = 'JFK' plane = '777-300' start = '1700' duration = 420 )
        ).

      when 'LH'.
        mt_connections = value #(
          ( id = '400'  from = 'FRA' to = 'BOS' plane = '330-300' start = '1750' duration = 460 )
          ( id = '420'  from = 'FRA' to = 'JFK' plane = '747-800' start = '1710' duration = 450 )
          ( id = '453'  from = 'LAX' to = 'MUC' plane = '380-800' start = '1720' duration = 630 )
          ( id = '543'  from = 'BOG' to = 'FRA' plane = '340-600' start = '2055' duration = 620 )
          ( id = '723'  from = 'PEK' to = 'MUC' plane = '380-800' start = '0035' duration = 540 )
          ( id = '1124' from = 'FRA' to = 'BCN' plane = '321-200' start = '0730' duration = 92 )
          ( id = '1126' from = 'FRA' to = 'BCN' plane = '321-200' start = '0945' duration = 92 )
          ( id = '1128' from = 'FRA' to = 'BCN' plane = '321-200' start = '1315' duration = 92 )
          ( id = '1130' from = 'FRA' to = 'BCN' plane = '321-200' start = '1105' duration = 92 )
          ( id = '1132' from = 'FRA' to = 'BCN' plane = '321-200' start = '1605' duration = 92 )
          ( id = '1134' from = 'FRA' to = 'BCN' plane = '321-200' start = '1405' duration = 92 )
          ( id = '1136' from = 'FRA' to = 'BCN' plane = '321-200' start = '1750' duration = 92 )
          ( id = '1138' from = 'FRA' to = 'BCN' plane = '321-200' start = '2100' duration = 92 )
          ( id = '1284' from = 'FRA' to = 'ATH' plane = '321-200' start = '2030' duration = 140 )
          ( id = '1792' from = 'MUC' to = 'LIS' plane = '321-200' start = '1930' duration = 180 )
        ).

    endcase.

    loop at mt_connections assigning field-symbol(<ls_connection>).
      if <ls_connection>-pets is initial.
        <ls_connection>-pets = 5.
      endif.
    endloop.

  endmethod.

endclass.

class lcl_airlines_data definition final.

  public section.

    types:
      tt_airlines type standard table of zcaa701_carriers with default key.

    methods:
      constructor,
      generate.

    data:
      mt_airlines type tt_airlines read-only.

endclass.
class lcl_airlines_data implementation.

  method constructor.

    mt_airlines = value tt_airlines(
      ( carrid = 'AA' carrname = 'American Airlines'    url = 'http://www.aa.com' )
      ( carrid = 'AB' carrname = 'Air Berlin'           url = 'http://www.airberlin.de       ' )
      ( carrid = 'AC' carrname = 'Air Canada'           url = 'http://www.aircanada.ca       ' )
      ( carrid = 'AF' carrname = 'Air France'           url = 'http://www.airfrance.fr       ' )
      ( carrid = 'AZ' carrname = 'Alitalia'             url = 'http://www.alitalia.it        ' )
      ( carrid = 'BA' carrname = 'British Airways'      url = 'http://www.british-airways.com' )
      ( carrid = 'CO' carrname = 'Continental Airlines' url = 'http://www.continental.com    ' )
      ( carrid = 'IB' carrname = 'IBERIA Airlines'      url = 'http://www.iberia.com'          )
      ( carrid = 'DL' carrname = 'Delta Airlines'       url = 'http://www.delta-air.com      ' )
      ( carrid = 'FJ' carrname = 'Air Pacific'          url = 'http://www.airpacific.com     ' )
      ( carrid = 'JL' carrname = 'Japan Airlines'       url = 'http://www.jal.co.jp          ' )
      ( carrid = 'LH' carrname = 'Lufthansa'            url = 'http://www.lufthansa.com      ' )
      ( carrid = 'NG' carrname = 'Lauda Air'            url = 'http://www.laudaair.com       ' )
      ( carrid = 'NW' carrname = 'Northwest Airlines'   url = 'http://www.nwa.com            ' )
      ( carrid = 'QF' carrname = 'Qantas Airways'       url = 'http://www.qantas.com.au      ' )
      ( carrid = 'SA' carrname = 'South African Air.'   url = 'http://www.saa.co.za          ' )
      ( carrid = 'FR' carrname = 'Ryanair'              url = 'http://www.ryanair.com        ' )
      ( carrid = 'SQ' carrname = 'Singapore Airlines'   url = 'http://www.singaporeair.com   ' )
      ( carrid = 'SR' carrname = 'Swiss'                url = 'http://www.swiss.com          ' )
      ( carrid = 'UA' carrname = 'United Airlines'      url = 'http://www.ual.com            ' )
    ).

  endmethod.

  method generate.

    delete from zcaa701_carriers.

    loop at mt_airlines assigning field-symbol(<ls_airline>).
      insert into zcaa701_carriers values @<ls_airline>.
    endloop.
    commit work.

  endmethod.

endclass.

class lcl_airplanes_data definition final.

  public section.

    types:
      tt_airplanes type standard table of zcaa701_planes with default key.

    methods:
      constructor,
      generate.

    data:
      mt_airplanes type tt_airplanes read-only.

endclass.
class lcl_airplanes_data implementation.

  method constructor.

    mt_airplanes = value #(
      ( planetype = '146-200   ' seatsmax =     112 producer = 'BA      ' seatsmax_b =       11 seatsmax_f =        11 )
      ( planetype = '146-300   ' seatsmax =     128 producer = 'BA      ' seatsmax_b =       11 seatsmax_f =        11 )
      ( planetype = '727-200   ' seatsmax =     189 producer = 'BOE     ' seatsmax_b =       18 seatsmax_f =        11 )
      ( planetype = '737-200SF ' seatsmax =      13 producer = 'BOE     ' seatsmax_b =        0 seatsmax_f =         0 )
      ( planetype = '737-400   ' seatsmax =     138 producer = 'BOE     ' seatsmax_b =       11 seatsmax_f =        10 )
      ( planetype = '737-800   ' seatsmax =     140 producer = 'BOE     ' seatsmax_b =       12 seatsmax_f =        10 )
      ( planetype = '747-200F  ' seatsmax =     171 producer = 'BOE     ' seatsmax_b =       17 seatsmax_f =        11 )
      ( planetype = '747-400   ' seatsmax =     385 producer = 'BOE     ' seatsmax_b =       31 seatsmax_f =        21 )
      ( planetype = '747-800   ' seatsmax =     385 producer = 'BOE     ' seatsmax_b =       31 seatsmax_f =        21 )
      ( planetype = '757F      ' seatsmax =     239 producer = 'BOE     ' seatsmax_b =       21 seatsmax_f =        16 )
      ( planetype = '767-200   ' seatsmax =     260 producer = 'BOE     ' seatsmax_b =       21 seatsmax_f =        11 )
      ( planetype = '767-300   ' seatsmax =     302 producer = 'BOE     ' seatsmax_b =       31 seatsmax_f =        11 )
      ( planetype = '777-200   ' seatsmax =     280 producer = 'BOE     ' seatsmax_b =       25 seatsmax_f =        8  )
      ( planetype = '777-300   ' seatsmax =     300 producer = 'BOE     ' seatsmax_b =       35 seatsmax_f =        25 )
      ( planetype = '787-800   ' seatsmax =     285 producer = 'BOE     ' seatsmax_b =       35 seatsmax_f =        8  )
      ( planetype = '787-900   ' seatsmax =     299 producer = 'BOE     ' seatsmax_b =       35 seatsmax_f =        8  )
      ( planetype = '300-600ST ' seatsmax =     230 producer = 'BOE     ' seatsmax_b =       20 seatsmax_f =        10 )
      ( planetype = '310-200   ' seatsmax =     280 producer = 'A       ' seatsmax_b =       34 seatsmax_f =        17 )
      ( planetype = '310-200F  ' seatsmax =      10 producer = 'A       ' seatsmax_b =        0 seatsmax_f =         0 )
      ( planetype = '310-200ST ' seatsmax =       8 producer = 'A       ' seatsmax_b =        0 seatsmax_f =         0 )
      ( planetype = '310-300   ' seatsmax =     280 producer = 'A       ' seatsmax_b =       22 seatsmax_f =        10 )
      ( planetype = '319-100   ' seatsmax =     120 producer = 'A       ' seatsmax_b =        8 seatsmax_f =         8 )
      ( planetype = '320-200   ' seatsmax =     130 producer = 'A       ' seatsmax_b =       10 seatsmax_f =         8 )
      ( planetype = '321-200   ' seatsmax =     150 producer = 'A       ' seatsmax_b =       16 seatsmax_f =        12 )
      ( planetype = '330-200   ' seatsmax =     223 producer = 'A       ' seatsmax_b =       22 seatsmax_f =        11 )
      ( planetype = '330-300   ' seatsmax =     223 producer = 'A       ' seatsmax_b =       22 seatsmax_f =        11 )
      ( planetype = '340-300   ' seatsmax =     310 producer = 'A       ' seatsmax_b =       20 seatsmax_f =        0 )
      ( planetype = '340-600   ' seatsmax =     330 producer = 'A       ' seatsmax_b =       30 seatsmax_f =        20 )
      ( planetype = '380-800   ' seatsmax =     475 producer = 'A       ' seatsmax_b =       30 seatsmax_f =        20 )
      ( planetype = 'CONCORDE  ' seatsmax =      20 producer = 'ASP     ' seatsmax_b =       20 seatsmax_f =        60 )
      ( planetype = 'DC-10-10  ' seatsmax =     230 producer = 'DC      ' seatsmax_b =       15 seatsmax_f =         6 )
      ( planetype = 'DC-8-72   ' seatsmax =     201 producer = 'DC      ' seatsmax_b =       21 seatsmax_f =        11 )
      ( planetype = 'DO328     ' seatsmax =      33 producer = 'DO      ' seatsmax_b =        4 seatsmax_f =         3 )
      ( planetype = 'FOKKER 100' seatsmax =     107 producer = 'FOK     ' seatsmax_b =       11 seatsmax_f =        11 )
      ( planetype = 'FOKKER 70 ' seatsmax =      79 producer = 'FOK     ' seatsmax_b =        6 seatsmax_f =         4 )
      ( planetype = 'L-1011-100' seatsmax =     400 producer = 'LOC     ' seatsmax_b =       41 seatsmax_f =        11 )
      ( planetype = 'MD11      ' seatsmax =     260 producer = 'DC      ' seatsmax_b =       20 seatsmax_f =        10 )
      ( planetype = 'RJ115     ' seatsmax =     128 producer = 'AVR     ' seatsmax_b =       11 seatsmax_f =        11 )
      ( planetype = 'RJ85      ' seatsmax =     112 producer = 'AVR     ' seatsmax_b =       11 seatsmax_f =        11 )
      ( planetype = 'YAK-242   ' seatsmax =     180 producer = 'YAK     ' seatsmax_b =       11 seatsmax_f =        11 )

    ).

  endmethod.

  method generate.
    delete from zcaa701_planes.
    loop at mt_airplanes assigning field-symbol(<ls_airplane>).
      insert into zcaa701_planes values @<ls_airplane>.
    endloop.
    commit work.
  endmethod.

endclass.


class lcl_airports_data definition final.

  public section.
    methods:
      constructor,
      generate.

  private section.
    types:
      _tt_airports type standard table of zcaa701_airports with default key.

    data:
      _mt_airports type _tt_airports.

endclass.
class lcl_airports_data implementation.

  method constructor.

    _mt_airports = value #(
      ( id = 'ACA' name = 'Acapulco, Mexico         ' time_zone = 'UTC-6    ' )
      ( id = 'ACE' name = 'Lanzarote, Canary IS     ' time_zone = 'UTC      ' )
      ( id = 'AIY' name = 'Atlantic City, USA       ' time_zone = 'UTC-5    ' )
      ( id = 'ASP' name = 'Alice Springs, AUS       ' time_zone = 'UTC+9    ' )
      ( id = 'BKK' name = 'Bangkok, Thailand        ' time_zone = 'UTC+7    ' )
      ( id = 'BNA' name = 'Nashville, USA           ' time_zone = 'UTC-5    ' )
      ( id = 'BOS' name = 'Boston Logan Int, USA    ' time_zone = 'UTC-5    ' )
      ( id = 'CDG' name = 'Paris Charles de Gaulle,F' time_zone = 'UTC+1    ' )
      ( id = 'DEN' name = 'Denver Int., USA         ' time_zone = 'UTC-7    ' )
      ( id = 'ELP' name = 'El Paso Int., USA        ' time_zone = 'UTC-7    ' )
      ( id = 'EWR' name = 'New York Newark Int., USA' time_zone = 'UTC-5    ' )
      ( id = 'FCO' name = 'Rome Leonardo Da Vinci, I' time_zone = 'UTC+1    ' )
      ( id = 'FRA' name = 'Frankfurt/Main, FRG      ' time_zone = 'UTC+1    ' )
      ( id = 'GCJ' name = 'Johannesburg Grand C., SA' time_zone = 'UTC+2    ' )
      ( id = 'GIG' name = 'Rio De Janeiro Int., BRA ' time_zone = 'UTC-3    ' )
      ( id = 'HAM' name = 'Hamburg, FRG             ' time_zone = 'UTC+1    ' )
      ( id = 'HIJ' name = 'Hiroshima, Japan         ' time_zone = 'UTC+9    ' )
      ( id = 'HKG' name = 'Hongkong                 ' time_zone = 'UTC+8    ' )
      ( id = 'HOU' name = 'Houston Hobby Apt, USA   ' time_zone = 'UTC-6    ' )
      ( id = 'HRE' name = 'Harare, Zimbabwe         ' time_zone = 'UTC+2    ' )
      ( id = 'ITM' name = 'Osaka Itami Apt, Japan   ' time_zone = 'UTC+9    ' )
      ( id = 'JFK' name = 'New York JF Kennedy, USA ' time_zone = 'UTC-5    ' )
      ( id = 'JKT' name = 'Jakarta, Indonesia       ' time_zone = 'UTC+7    ' )
      ( id = 'KIX' name = 'Osaka Kansai Int., Japan ' time_zone = 'UTC+9    ' )
      ( id = 'KUL' name = 'Kuala Lumpur, Malaysia   ' time_zone = 'UTC+8    ' )
      ( id = 'LAS' name = 'Las Vegas Mc Carran, USA ' time_zone = 'UTC-8    ' )
      ( id = 'LAX' name = 'Los Angeles Int Apt, USA ' time_zone = 'UTC-8    ' )
      ( id = 'LCY' name = 'London City Apt, UK      ' time_zone = 'UTC      ' )
      ( id = 'LGW' name = 'London Gatwick Apt, UK   ' time_zone = 'UTC      ' )
      ( id = 'LHR' name = 'London Heathrow Apt, UK  ' time_zone = 'UTC      ' )
      ( id = 'MAD' name = 'Madrid Barajas Apt, Spain' time_zone = 'UTC+1    ' )
      ( id = 'MCI' name = 'Kansas City Int Apt, USA ' time_zone = 'UTC-6    ' )
      ( id = 'MIA' name = 'Miami Int Apt, USA       ' time_zone = 'UTC-5    ' )
      ( id = 'MUC' name = 'Munich, FRG              ' time_zone = 'UTC+1    ' )
      ( id = 'NRT' name = 'Tokyo Narita, Japan      ' time_zone = 'UTC+9    ' )
      ( id = 'ORY' name = 'Paris Orly Apt, France   ' time_zone = 'UTC+1    ' )
      ( id = 'PID' name = 'Nassau Paradise IS,Bahama' time_zone = 'UTC-5    ' )
      ( id = 'RTM' name = 'Rotterdam Apt, NL        ' time_zone = 'UTC+1    ' )
      ( id = 'SEL' name = 'Seoul Kimpo Int, ROK     ' time_zone = 'UTC+9    ' )
      ( id = 'SFO' name = 'San Francisco Int Apt,USA' time_zone = 'UTC-8    ' )
      ( id = 'SIN' name = 'Singapore                ' time_zone = 'UTC+8    ' )
      ( id = 'STO' name = 'Stockholm, Sweden        ' time_zone = 'UTC+1    ' )
      ( id = 'SVO' name = 'Moscow Sheremetyevo Apt,R' time_zone = 'UTC+3    ' )
      ( id = 'SXF' name = 'Berlin Schonefeld Apt,FRG' time_zone = 'UTC+1    ' )
      ( id = 'THF' name = 'Berlin Tempelhof Apt, FRG' time_zone = 'UTC+1    ' )
      ( id = 'TXL' name = 'Berlin Tegel Apt, FRG    ' time_zone = 'UTC+1    ' )
      ( id = 'TYO' name = 'Tokyo, JAPAN             ' time_zone = 'UTC+9    ' )
      ( id = 'VCE' name = 'Venice Marco Polo Apt, I ' time_zone = 'UTC+1    ' )
      ( id = 'VIE' name = 'Vienna, Austria          ' time_zone = 'UTC+1    ' )
      ( id = 'VKO' name = 'Moscow Vnukovo Apt, R    ' time_zone = 'UTC+3    ' )
      ( id = 'YEG' name = 'Edmonton Int Apt, CDN    ' time_zone = 'UTC-7    ' )
      ( id = 'YOW' name = 'Ottawa Uplands Int., CDN ' time_zone = 'UTC-5    ' )
      ( id = 'ZRH' name = 'Zurich, Switzerland      ' time_zone = 'UTC+1    ' )
    ).

  endmethod.

  method generate.
    delete from zcaa701_airports.
    loop at _mt_airports assigning field-symbol(<ls_airport>).
      insert into zcaa701_airports values @<ls_airport>.
    endloop.
    commit work.
  endmethod.

endclass.

class lcl_sflight_data definition.

  public section.
    methods:
      constructor,
      generate.

  private section.

    methods:
      _generate_connection
        importing
          iv_carrid     type zcaa701_carrid
          is_connection type lcl_airline=>ty_connection,

      _generate_pets
        importing
          iv_total  type i
          is_flight type zcaa701_sflight,

      _get_airline
        returning
          value(rs_data) type zcaa701_sflight.

    data:
      _mv_pet_counter type i.

    data:
      _mt_pets type standard table of zcaa701_pettype.

endclass.
class lcl_sflight_data implementation.

  method constructor.
    _mt_pets = value #( ( 'C' ) ( 'D' ) ( 'T' ) ).
  endmethod.
  method generate.

    data:
      ls_sflight type zcaa701_sflight,
      lv_date  type d.

    data:
      lo_airlines  type ref to lcl_airlines_data,
      lo_airline   type ref to lcl_airline,
      lo_airplanes type ref to lcl_airplanes_data.

    lo_airlines  = new lcl_airlines_data( ).
    lo_airplanes = new lcl_airplanes_data( ).

    get time stamp field data(lv_timestamp).
    lv_date = |{ lv_timestamp align = left }| .

    _mv_pet_counter = 0.

    delete from zcaa701_sflight.
    delete from zcaa701_sflightp.
    delete from zcaa701_conn.
    commit work.

    loop at lo_airlines->mt_airlines assigning field-symbol(<ls_airline>).
      lo_airline = new lcl_airline( <ls_airline>-carrid ).

      ls_sflight-carrid = <ls_airline>-carrid.
      loop at lo_airline->mt_connections assigning field-symbol(<ls_connection>).
        ls_sflight-connid = <ls_connection>-id.
        ls_sflight-fldate = lv_date - 105.

        _generate_connection( iv_carrid = <ls_airline>-carrid  is_connection = <ls_connection> ).

        do 256 times.
          ls_sflight-fldate   = lv_date + sy-index.
          ls_sflight-price    = lcl_utils=>random( iv_min = 30000 iv_max = 150000 ) / 100.
          ls_sflight-currency = 'USD'.
          ls_sflight-planetype = <ls_connection>-plane.

          read table lo_airplanes->mt_airplanes with key planetype = <ls_connection>-plane assigning field-symbol(<ls_airplane>).
          if sy-subrc eq 0.
            ls_sflight-seatsmax   = <ls_airplane>-seatsmax.
            ls_sflight-seatsmax_b = <ls_airplane>-seatsmax_b.
            ls_sflight-seatsmax_f = <ls_airplane>-seatsmax_f.

            ls_sflight-seatsocc   = lcl_utils=>random( iv_min = ( ls_sflight-seatsmax / 3 ) iv_max = ls_sflight-seatsmax ).
            if ls_sflight-seatsmax_b > 0.
              ls_sflight-seatsocc_b = lcl_utils=>random( iv_min = ( ls_sflight-seatsmax_b / 3 ) iv_max = ls_sflight-seatsmax_b ).
            else.
              ls_sflight-seatsocc_b = 0.
            endif.

            if ls_sflight-seatsmax_f > 0.
              ls_sflight-seatsocc_f = lcl_utils=>random( iv_min = 0 iv_max = ls_sflight-seatsmax_f ).
            else.
              ls_sflight-seatsocc_f = 0.
            endif.

            ls_sflight-paymentsum = ( ls_sflight-price * ls_sflight-seatsocc ) +
                                    ( ls_sflight-price * ls_sflight-seatsocc_b * 2 ) +
                                    ( ls_sflight-price * ls_sflight-seatsocc_f * 4 ).


            insert into zcaa701_sflight values @ls_sflight.

            _generate_pets( iv_total = <ls_connection>-pets  is_flight = ls_sflight ).

          endif.

        enddo.
      endloop.
      commit work.
    endloop.

    commit work.

  endmethod.

  method _get_airline.

  endmethod.

  method _generate_connection.

    data:
      ls_connection type zcaa701_conn.

    ls_connection = value #( carrid       = iv_carrid
                             connid       = is_connection-id
                             airport_from = is_connection-from
                             airport_to   = is_connection-to
                             takeoff      = is_connection-start
                             duration     = is_connection-duration
                             max_pets     = is_connection-pets
                           ).

    insert into zcaa701_conn values @ls_connection.

  endmethod.

  method _generate_pets.

    data:
      ls_pet   type zcaa701_sflightp,
      lv_total type i.

    _mv_pet_counter += 1.
    if _mv_pet_counter mod 6 <> 0.
      return.
    endif.

    lv_total = lcl_utils=>random( iv_min = 0 iv_max = iv_total ).

    do lv_total times.
      ls_pet-carrid = is_flight-carrid.
      ls_pet-connid = is_flight-connid.
      ls_pet-fldate = is_flight-fldate.
      ls_pet-petid  = sy-index.
      ls_pet-type   = _mt_pets[ lcl_utils=>random( iv_min = 1 iv_max = 3 ) ].
      ls_pet-weight = lcl_utils=>random( iv_min = 800 iv_max = 45000 ) / 1000.
      ls_pet-height = lcl_utils=>random( iv_min = 18 iv_max = 57 ).

      insert into zcaa701_sflightp values @ls_pet.

    enddo.

  endmethod.


endclass.
