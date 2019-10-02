class zcl_caa701_initialize_tpl definition public final create public .

  public section.
    interfaces:
      if_oo_adt_classrun.

    methods:
      generate.

  protected section.

  private section.

    methods:
      _airports,
      _airlines,
      _airplanes,
      _flights,
      _flight_pet_rule.


endclass.

class zcl_caa701_initialize_tpl implementation.

  method generate.

    _airports( ).
    _airlines( ).
    _airplanes( ).
    _flights( ).
    _flight_pet_rule( ).

  endmethod.

  method _flight_pet_rule.

  endmethod.

  method _flights.

    data:
      lo_flights type ref to lcl_sflight_data.

    lo_flights = new lcl_sflight_data( ).

    lo_flights->generate( ).

  endmethod.

  method _airlines.
    new lcl_airlines_data( )->generate( ).
  endmethod.

  method _airports.
    new lcl_airports_data( )->generate( ).
  endmethod.

  method _airplanes.
    new lcl_airplanes_data( )->generate( ).
  endmethod.


  method if_oo_adt_classrun~main.

    data:
      lo_handler type ref to zcl_caa701_initialize_tpl.

    lo_handler = new zcl_caa701_initialize_tpl( ).

    lo_handler->generate( ).

    out->write( 'Generated successfully' ).

  endmethod.

endclass.

