CLASS lhc_registrations DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS GenerateRegistrationId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registrations~GenerateRegistrationId.
    METHODS SetRegistrationstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registrations~SetRegistrationstatus.
    METHODS MaxParticipantsNotReached FOR VALIDATE ON SAVE
      IMPORTING keys FOR Registrations~MaxParticipantsNotReached.

ENDCLASS.

CLASS lhc_registrations IMPLEMENTATION.

  METHOD GenerateRegistrationId.
   SELECT FROM zregistration_4 FIELDS MAX( registration_id ) INTO @DATA(max_event_id).
    DATA(registration_id) = max_event_id + 1.

    MODIFY ENTITY IN LOCAL MODE ZR_Registration_4
           UPDATE FIELDS ( RegistrationId )
           WITH VALUE #( FOR key IN keys
                         ( %tky     = key-%tky
                           RegistrationId = registration_id ) ).
  ENDMETHOD.

  METHOD SetRegistrationstatus.
    MODIFY ENTITY IN LOCAL MODE ZR_Registration_4
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = 'New' ) ).
  ENDMETHOD.

  METHOD MaxParticipantsNotReached.
    DATA message TYPE REF TO zcm_event_4.

    READ ENTITY IN LOCAL MODE ZR_Registration_4
         FIELDS ( EventUuid )
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations INTO DATA(registration).
      DATA all_events     TYPE TABLE OF zevent_4.
      DATA filtered_event TYPE zevent_4.

      SELECT *
        FROM zevent_4
        INTO TABLE @all_events.

      LOOP AT all_events ASSIGNING FIELD-SYMBOL(<row>).
        IF <row>-event_uuid = registration-EventUuid.
          filtered_event = <row>.
        ENDIF.
      ENDLOOP.

      DATA all_registrations     TYPE TABLE OF zregistration_4.
      DATA filtered_registrations TYPE TABLE OF zregistration_4.

      SELECT *
        FROM zregistration_4
        INTO TABLE @all_registrations.


      LOOP AT all_registrations ASSIGNING FIELD-SYMBOL(<row_reg>).
        IF <row_reg>-event_uuid = filtered_event-event_uuid.
          APPEND <row_reg> TO filtered_registrations.
        ENDIF.
      ENDLOOP.

      IF filtered_event-max_participants <= lines( filtered_registrations ).
        message = NEW zcm_event_4( textid = zcm_event_4=>max_participants_reached ).
        APPEND VALUE #( %tky = registration-%tky
                        %msg = message ) TO reported-event.
        APPEND VALUE #( %tky = registration-%tky ) TO failed-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

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

    METHODS CloseEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~CloseEvent RESULT result.

    METHODS OpenEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~OpenEvent RESULT result.

    METHODS ValidateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Event~ValidateDates.
    METHODS ValidateStartDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Event~ValidateStartDate.

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

  METHOD CloseEvent.
    READ ENTITY IN LOCAL MODE zr_eventtp_4
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    " Process Data
    LOOP AT events REFERENCE INTO DATA(event).

      " Set Status to another value
      event->Status = 'C'.
    ENDLOOP.

    " Modify Data
    MODIFY ENTITY IN LOCAL MODE zr_eventtp_4
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN events
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN events
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD OpenEvent.
    READ ENTITY IN LOCAL MODE zr_eventtp_4
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    " Process Data
    LOOP AT events REFERENCE INTO DATA(event).

      " Set Status to another value
      event->Status = 'O'.
    ENDLOOP.

    " Modify Data
    MODIFY ENTITY IN LOCAL MODE zr_eventtp_4
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN events
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN events
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD ValidateDates.
    DATA message TYPE REF TO zcm_event_4.

    READ ENTITY IN LOCAL MODE zr_eventtp_4
         FIELDS ( StartDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events INTO DATA(event).
      IF event-EndDate < event-StartDate.
        message = NEW zcm_event_4( textid = zcm_event_4=>invalid_dates ).
        APPEND VALUE #( %tky = event-%tky
                        %msg = message ) TO reported-event.
        APPEND VALUE #( %tky = event-%tky ) TO failed-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateStartDate.
    DATA message TYPE REF TO zcm_event_4.
    DATA lv_date TYPE d.
    lv_date = cl_abap_context_info=>get_system_date( ).


    READ ENTITY IN LOCAL MODE zr_eventtp_4
         FIELDS ( StartDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(events).

    LOOP AT events INTO DATA(event).
      IF event-StartDate < lv_date.
        message = NEW zcm_event_4( textid = zcm_event_4=>invalid_startdate ).
        APPEND VALUE #( %tky = event-%tky
                        %msg = message ) TO reported-event.
        APPEND VALUE #( %tky = event-%tky ) TO failed-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
