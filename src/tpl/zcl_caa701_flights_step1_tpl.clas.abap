class zcl_caa701_flights_step1_tpl definition public final create public .

  public section.
    interfaces:
      if_oo_adt_classrun.

    types:
      ty_carr_id type c length 3,
      ty_conn_id type n length 4,

      begin of ty_flight,
        fldate type d,
        carrid type zcaa701_carrid,
        connid type zcaa701_sflight-connid,
        from   type zcaa701_airportid,
        to     type zcaa701_airportid,
        price  type zcaa701_sflight-price,
      end of ty_flight,

      begin of ty_avgprice,
        carrid    type zcaa701_carrid,
        avg_price type zcaa701_sflight-price,
      end of ty_avgprice,

      tt_avgprice type standard table of ty_avgprice with default key,
      tt_flights  type standard table of ty_flight   with default key,

      begin of ty_result,
        next      type ty_flight,
        cheap     type ty_flight,
        expensive type ty_flight,
      end of ty_result.

    methods:
      constructor,
      "! <p class="shorttext synchronized" lang="en">Search list of flights with availability to carry pets</p>
      "! After identifying the list of possible flights to carry pets on board, the following is calculated: <br>
      "!    1. Next flight <br>
      "!    2. Cheapest flight <br>
      "!    3. Most expensive flight <br>
      "!    4. Convert the list of flights into a string separated by , <br>
      "! @parameter iv_date        | Start searching date
      "! @parameter iv_origin      | Starting airport
      "! @parameter iv_destination | Final destination
      "! @parameter rt_result      | List of possible flights
      get_pet_availability
        importing
          iv_date          type d
          iv_origin        type zcaa701_airportid
          iv_destination   type zcaa701_airportid
        returning
          value(rt_result) type ty_result,

      "! <p class="shorttext synchronized" lang="en">Compute the average price per airline for a determined route</p>
      "!
      "! @parameter iv_origin      | <p class="shorttext synchronized" lang="en">Starting airport</p>
      "! @parameter iv_destination | <p class="shorttext synchronized" lang="en">Final destination</p>
      "! @parameter rt_results     | <p class="shorttext synchronized" lang="en">List of average price per airline</p>
      compute_average_price
        importing
          !iv_origin        type zcaa701_airportid
          !iv_destination   type zcaa701_airportid
        returning
          value(rt_results) type tt_avgprice,

      "! <p class="shorttext synchronized" lang="en">Return list of flights costing less than the maximum price</p>
      "!
      "! @parameter iv_max_price | <p class="shorttext synchronized" lang="en">Maximum price</p>
      "! @parameter rt_flights   | <p class="shorttext synchronized" lang="en">List of flights which match the criteria</p>
      get_flights_by_price
        importing
          !iv_max_price     type zcaa701_sflight-price
        returning
          value(rt_flights) type tt_flights.

  protected section.
  private section.

    data:
      _mv_today              type d,
      _mv_flights_serialized type string.

    data:
      _mt_flights type sorted table of ty_flight with non-unique key price.

endclass.

class zcl_caa701_flights_step1_tpl implementation.

  method constructor.

    get time stamp field data(lv_timestamp).
    _mv_today = |{ lv_timestamp align = left }| .

    select
      from zcaa701_sflight as flight
      left join zcaa701_conn as conn on flight~carrid = conn~carrid and flight~connid = conn~connid
      fields flight~fldate, flight~carrid, flight~connid, conn~airport_from, conn~airport_to, flight~price
      order by price
      into table @_mt_flights.

  endmethod.

  method get_pet_availability.

    types:
      begin of ty_flight,
        fldate type d,
        carrid type zcaa701_carrid,
        connid type zcaa701_conn-connid,
        price  type zcaa701_sflight-price,
      end of ty_flight,

      "-------------------------------------------------------------------------------------------------------
      " STEP 1 - INLINE DECLARATION: Remove Type definition
      " ty_flight_pet
      " ty_flightsel
      " tt_flightsel
      " tt_flight_pets
      "-------------------------------------------------------------------------------------------------------
      begin of ty_flight_pet,
        fldate type d,
        carrid type zcaa701_carrid,
        connid type zcaa701_conn-connid,
        total  type i,
      end of ty_flight_pet,

      begin of ty_flightsel,
        fldate   type d,
        carrid   type zcaa701_carrid,
        connid   type zcaa701_conn-connid,
        max_pets type i,
        occ_pets type i,
        price    type zcaa701_sflight-price,
        currency type zcaa701_sflight-currency,
      end of ty_flightsel,

      tt_flightsel   type standard table of ty_flightsel  with default key,
      tt_flight_pets type sorted   table of ty_flight_pet with unique key fldate carrid connid.


    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION: Constant declaration
    " This constant is used as host variable in ABAP SQL for easy typing definition
    "
    "  constants:
    "    co_occ_pets type i value 0.
    "-------------------------------------------------------------------------------------------------------

    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION: Remove Variable declaration
    " lt_flight_pets
    " lt_flights
    "-------------------------------------------------------------------------------------------------------
    data:
      lt_flight_pets type tt_flight_pets,
      lv_index       type i,
      lt_flights     type tt_flightsel.


    "-------------------------------------------------------------------------------------------------------
    " STEP 1 INLINE DECLARATION: Remove Field-symbols declaration
    " <ls_flight>
    " <ls_flight_pet>
    "-------------------------------------------------------------------------------------------------------
    field-symbols:
      <ls_flight>     type ty_flightsel,
      <ls_flight_pet> type ty_flight_pet.

    "Retrieve flight with pets information
    "-------------------------------------------------------------------------------------------------------
    " STEP 1 INLINE DECLARATION: Field name adjusting
    " fields pets~fldate, pets~carrid, pets~connid, count( * ) as total
    "-------------------------------------------------------------------------------------------------------
    select from zcaa701_sflightp as pets
     inner join zcaa701_conn as connection on pets~carrid = connection~carrid and
                                              pets~connid = connection~connid
    fields pets~fldate, pets~carrid, pets~connid, count( * ) as pets
     where pets~fldate >= @iv_date
       and connection~airport_from = @iv_origin
       and connection~airport_to   = @iv_destination
       and connection~max_pets     > 0
     group by pets~fldate, pets~carrid, pets~connid
     order by pets~fldate, pets~carrid, pets~connid
     "-------------------------------------------------------------------------------------------------------
     " STEP 1 - INLINE DECLARATION
     " into table @data(lt_flight_pets).
     "-------------------------------------------------------------------------------------------------------
      into table @lt_flight_pets.

    "Retrieve available flights
    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION
    " Add a new column to the selection list as type requires additional column occ_pets type i
    " fields flight~fldate, flight~carrid, flight~connid, connection~max_pets, flight~price, flight~currency, @co_occ_pets as occ_pets
    "-------------------------------------------------------------------------------------------------------
    select from zcaa701_sflight as flight
     inner join zcaa701_conn as connection on flight~carrid = connection~carrid and
                                              flight~connid = connection~connid
    fields flight~fldate, flight~carrid, flight~connid, connection~max_pets, flight~price, flight~currency
     where flight~fldate >= @iv_date
       and connection~airport_from = @iv_origin
       and connection~airport_to   = @iv_destination
       and connection~max_pets     > 0
     order by flight~fldate
     "-------------------------------------------------------------------------------------------------------
     " STEP 1 - INLINE DECLARATION
     " into table @data(lt_flights).
     "-------------------------------------------------------------------------------------------------------
     into corresponding fields of table @lt_flights.

    "-------------------------------------------------------------------------------------------------------
    " STEP 1- INLINE DECLARATION
    " loop at lt_flights assigning field-symbol(<ls_flight>).
    "-------------------------------------------------------------------------------------------------------
    loop at lt_flights assigning <ls_flight>.
      lv_index = sy-tabix.
      read table lt_flight_pets with key fldate = <ls_flight>-fldate
                                         carrid = <ls_flight>-carrid
                                         connid = <ls_flight>-connid

    "-------------------------------------------------------------------------------------------------------
    " STEP 1- INLINE DECLARATION
    " assigning field-symbol(<ls_flight_pet>).
    "-------------------------------------------------------------------------------------------------------
       assigning <ls_flight_pet>.
      if sy-subrc eq 0.
        <ls_flight>-occ_pets = <ls_flight_pet>-total.
        if <ls_flight>-occ_pets >= <ls_flight>-max_pets.
          delete lt_flights index lv_index.
        endif.
      else.
        delete lt_flights index lv_index.
      endif.
    endloop.

    "Get the first occurrence
    read table lt_flights index 1 assigning <ls_flight>.
    if sy-subrc eq 0.
      "-------------------------------------------------------------------------------------------------------
      " STEP 1- CONSTRUCTORS
      " rt_result-next = corresponding #( <ls_flight> ).
      "-------------------------------------------------------------------------------------------------------
      rt_result-next-carrid = <ls_flight>-carrid.
      rt_result-next-connid = <ls_flight>-connid.
      rt_result-next-fldate = <ls_flight>-fldate.
      rt_result-next-price  = <ls_flight>-price.
    endif.

    "Search the cheapest and most expensive flight
    rt_result-cheap-price     = 9999999.
    rt_result-expensive-price = 0.
    loop at lt_flights assigning <ls_flight>.
      if rt_result-cheap-price > <ls_flight>-price.
        "-------------------------------------------------------------------------------------------------------
        " STEP 1 - MOVE-CORRESPONDING
        " rt_result-cheap = corresponding #( <ls_flight> ).
        "-------------------------------------------------------------------------------------------------------
        move-corresponding <ls_flight> to rt_result-cheap.
      endif.
      if rt_result-expensive-price < <ls_flight>-price.
        "-------------------------------------------------------------------------------------------------------
        " STEP 1 - MOVE-CORRESPONDING
        " rt_result-expensive = corresponding #( <ls_flight> ).
        "-------------------------------------------------------------------------------------------------------
        move-corresponding <ls_flight> to rt_result-expensive.
      endif.
    endloop.

    "Prepare flight list to be displayed in the web as serialized string
    read table lt_flights index 1 assigning <ls_flight>.
    if sy-subrc eq 0.
      "-------------------------------------------------------------------------------------------------------
      " STEP 1 - CONCATENATE
      " _mv_flights_serialized = <ls_flight>-carrid && <ls_flight>-connid && <ls_flight>-fldate.
      "-------------------------------------------------------------------------------------------------------
      concatenate <ls_flight>-carrid <ls_flight>-connid <ls_flight>-fldate into _mv_flights_serialized.
    endif.
    loop at lt_flights assigning <ls_flight> from 2.
      "-------------------------------------------------------------------------------------------------------
      " STEP 1 - CONCATENATE
      " _mv_flights_serialized = ',' && _mv_flights && <ls_flight>-carrid && <ls_flight>-connid && <ls_flight>-fldate.
      "-------------------------------------------------------------------------------------------------------
      concatenate ',' _mv_flights_serialized <ls_flight>-carrid <ls_flight>-connid <ls_flight>-fldate into _mv_flights_serialized.
    endloop.

  endmethod.

  method compute_average_price.

    types:
      begin of ty_flights,
        carrid type zcaa701_carrid,
        price  type p length 8 decimals 2,
      end of ty_flights.

    data:
      lv_total   type p length 15 decimals 2,
      lv_counter type i,
      rt_result  type ty_avgprice.

    data:
      lt_flights type sorted table of ty_flights with non-unique key carrid.

    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION: Remove field symbol declaration
    " <ls_flight> type ty_flight,
    "-------------------------------------------------------------------------------------------------------
    field-symbols:
      <ls_flight> type ty_flights.

    lt_flights = value #( for ls_flight in _mt_flights where ( from = iv_origin and to = iv_destination ) ( carrid = ls_flight-carrid price = ls_flight-price ) ).

    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION
    " loop at lt_flights assigning field-symbol(<ls_flight>).
    "-------------------------------------------------------------------------------------------------------
    loop at lt_flights assigning <ls_flight>.

      lv_total   = lv_total + <ls_flight>-price.
      lv_counter = lv_counter + 1.

      at end of carrid.

        rt_result-carrid = <ls_flight>-carrid.
        rt_result-avg_price = lv_total / lv_counter.

        append rt_result to rt_results.

        lv_total   = 0.
        lv_counter = 0.
      endat.

    endloop.

  endmethod.


  method get_flights_by_price.

    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION: Remove field-symbol declaration
    "-------------------------------------------------------------------------------------------------------
    field-symbols:
      <ls_flight> type ty_flight.

    "-------------------------------------------------------------------------------------------------------
    " STEP 1 - INLINE DECLARATION
    " loop at _mt_flights assigning field-symbol(<ls_flight>).
    "-------------------------------------------------------------------------------------------------------
    loop at _mt_flights assigning <ls_flight>.
      if <ls_flight>-price < iv_max_price.
        append <ls_flight> to rt_flights.
      endif.
    endloop.

  endmethod.

  method if_oo_adt_classrun~main.

    field-symbols:
      <lt_result> type any table.

    data(scenario) = 1.  "<== Change Scenario Here

    case scenario.
      when 1.
        data(lt_price_list) = get_flights_by_price( 487 ).
        assign lt_price_list to <lt_result>.
      when 2.
        data(lt_price_avg) = compute_average_price( iv_origin = 'FRA' iv_destination = 'BCN' ).
        assign lt_price_avg to <lt_result>.
      when 3.
        data(lv_flights) = get_pet_availability( iv_date = '20200305' iv_origin = 'FRA' iv_destination = 'BCN' ).
    endcase.

    if scenario <> 3.
      out->write( data = <lt_result> name = 'Result' ).
      out->write( '----------------------------------------------------------' ).
      out->write( |# of entries: { lines( <lt_result> ) }| ).
    else.
      out->write( data = lv_flights-next name = 'Next flight' ).
      out->write( data = lv_flights-cheap name = 'Cheapest flight' ).
      out->write( data = lv_flights-expensive name = 'Priciest flight' ).
    endif.

  endmethod.

endclass.
