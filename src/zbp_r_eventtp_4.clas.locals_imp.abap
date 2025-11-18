CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Event RESULT result.
    METHODS GenerateEventId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Event~GenerateEventId.
    METHODS SetEventStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Event~SetEventStatus.

ENDCLASS.

CLASS lhc_Event IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD GenerateEventId.

    SELECT FROM zevent_4 FIELDS MAX( event_id ) INTO @DATA(max_event_id).
    DATA(event_id) = max_event_id + 1.

    MODIFY ENTITY IN LOCAL MODE zr_eventtp_4
           UPDATE FIELDS ( EventId )
           WITH VALUE #( FOR key IN keys
                         ( %tky     = key-%tky
                           EventId = event_id ) ).
  ENDMETHOD.

  METHOD SetEventStatus.
    MODIFY ENTITY IN LOCAL MODE zr_eventtp_4
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = 'P' ) ).
  ENDMETHOD.

ENDCLASS.
