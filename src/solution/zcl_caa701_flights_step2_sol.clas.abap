class zcl_caa701_flights_step2_sol definition public final create public .

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
      "!    1. Cheapest flight <br>
      "!    2. Most expensive flight <br>
      "!    3. Convert the list of flights into a string separated by , <br>
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

class zcl_caa701_flights_step2_sol implementation.

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
      end of ty_flight.

    "Retrieve flight with pets information
    with
      +pets as ( select fldate, carrid, connid, count( * ) as pets
                   from zcaa701_sflightp
                   group by fldate, carrid, connid )

    select
      from zcaa701_sflight as flight
      inner join zcaa701_conn as connection on flight~carrid = connection~carrid and
                                               flight~connid = connection~connid
      left  join +pets        as pets       on flight~fldate = pets~fldate       and
                                               flight~carrid = pets~carrid       and
                                               flight~connid = pets~connid
     fields flight~fldate, flight~carrid, flight~connid, connection~max_pets, pets~pets as occ_pets, flight~price, flight~currency
     where flight~fldate >= @iv_date
       and connection~airport_from = @iv_origin
       and connection~airport_to   = @iv_destination
       and connection~max_pets     > 0
       and pets~pets               <= connection~max_pets
     order by flight~fldate
      into table @data(lt_flights).

    "Get the first occurrence
    rt_result-next = corresponding #( value #( lt_flights[ 1 ] default value #(  ) ) ).


    "Search the cheapest and most expensive flight
    rt_result-cheap-price     = 9999999.

    rt_result-expensive-price = 0.
    loop at lt_flights assigning field-symbol(<ls_flight>).
      if rt_result-cheap-price > <ls_flight>-price.
        rt_result-cheap = corresponding #( <ls_flight> ).
      endif.
      if rt_result-expensive-price < <ls_flight>-price.
        rt_result-expensive = corresponding #( <ls_flight> ).
      endif.
    endloop.

    "Prepare flight list to be displayed in the web as serialized string
    data(ls_flight) = value #( lt_flights[ 1 ] default value #( ) ).
    if ls_flight is not initial.
      _mv_flights_serialized = ls_flight-carrid && ls_flight-connid && ls_flight-fldate.
      loop at lt_flights assigning <ls_flight> from 2.
        _mv_flights_serialized = ',' && _mv_flights_serialized && <ls_flight>-carrid && <ls_flight>-connid && <ls_flight>-fldate.
      endloop.
    endif.

  endmethod.

  method compute_average_price.

    types:
      begin of ty_flights,
        carrid type zcaa701_carrid,
        price  type p length 8 decimals 2,
      end of ty_flights.

    data:
      lv_total   type p length 15 decimals 2,
      lv_counter type i.

    data:
      lt_flights type sorted table of ty_flights with non-unique key carrid.

    lt_flights = value #( for ls_flight in _mt_flights where ( from = iv_origin and to = iv_destination ) ( carrid = ls_flight-carrid price = ls_flight-price ) ).

    loop at lt_flights assigning field-symbol(<ls_flight>) group by <ls_flight>-carrid assigning field-symbol(<lv_conns_by_carrid>).

      loop at group <lv_conns_by_carrid> assigning field-symbol(<ls_conn>).
        lv_total   += <ls_conn>-price.
        lv_counter += 1.
      endloop.

      if lv_counter > 0.
        append value #( carrid = <lv_conns_by_carrid> avg_price = lv_total / lv_counter ) to rt_results.
        lv_total   = 0.
        lv_counter = 0.
      endif.
    endloop.

  endmethod.


  method get_flights_by_price.

    data(lt_flights_up_to_max_price) = filter #( _mt_flights where price < iv_max_price ).

    rt_flights = lt_flights_up_to_max_price.

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
