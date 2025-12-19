CLASS zcl_group4_event_data_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_group4_event_data_gen IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
    
    DATA: lt_events        TYPE TABLE OF zevent_4,
          ls_event         TYPE zevent_4,
          lt_participants  TYPE TABLE OF zparticipant_4,
          ls_participant   TYPE zparticipant_4,
          lt_regs          TYPE TABLE OF zregistration_4,
          ls_reg           TYPE zregistration_4,
          lv_ts            TYPE timestampl.

    " DELETE OLD DATA
    
    DELETE FROM zregistration_4.
    out->write( |Deleted Registrations: { sy-dbcnt }| ).

    DELETE FROM zparticipant_4.
    out->write( |Deleted Participants: { sy-dbcnt }| ).

    DELETE FROM zevent_4.
    out->write( |Deleted Events: { sy-dbcnt }| ).

    " CREATE 8 CONCERT EVENTS
    
    DATA(concert_titles) = VALUE stringtab(
      ( |Northern Lights Rock| )
      ( |Berlin Acoustic Night| )
      ( |Classic Stars Gala| )
      ( |Electro Beats Festival| )
      ( |Smooth Jazz Sessions| )
      ( |Metal Inferno Live| )
      ( |Symphonic Dreams| )
      ( |Indie Vibes Open Air| )
    ).

    DATA(concert_locations) = VALUE stringtab(
      ( |Hamburg| )
      ( |Berlin| )
      ( |Hanover| )
      ( |Cologne| )
      ( |Bremen| )
      ( |Dortmund| )
      ( |Bremen| )
      ( |Leipzig| )
    ).

    DATA(concert_desc) = VALUE stringtab(
      ( |Rock concert featuring new European bands.| )
      ( |Acoustic evening with singer-songwriters.| )
      ( |Classical gala with international soloists.| )
      ( |Electronic music with international DJs.| )
      ( |Jazz concerts in a cozy atmosphere.| )
      ( |Heavy metal night with a pyro show.| 
      ( |Symphonic night with a large orchestra.| )
      ( |Indie festival featuring newcomer bands.| )
    ).

    DATA(concert_status) = VALUE stringtab(
      ( |O| ) ( |C| ) ( |C| ) ( |P| )
      ( |O| ) ( |P| ) ( |O| ) ( |O| )
    ).

    DO 8 TIMES.
      CLEAR ls_event.

      ls_event-client           = sy-mandt.
      ls_event-event_id         = |{ sy-index }|.
      ls_event-title            = concert_titles[ sy-index ].
      ls_event-location         = concert_locations[ sy-index ].
      ls_event-description      = concert_desc[ sy-index ].
      ls_event-status           = concert_status[ sy-index ].

      ls_event-start_date       = |20260{ sy-index }10|.
      ls_event-end_date         = |20260{ sy-index }12|.

      ls_event-max_participants = 500 + sy-index * 100.

      ls_event-event_uuid       = cl_system_uuid=>create_uuid_x16_static( ).
      ls_event-created_by       = 'GEN'.
      ls_event-last_changed_by  = 'GEN'.
      GET TIME STAMP FIELD ls_event-created_at.
      GET TIME STAMP FIELD ls_event-last_changed_at.

      APPEND ls_event TO lt_events.
    ENDDO.

    INSERT zevent_4 FROM TABLE @lt_events.
    out->write( |Inserted Events: { sy-dbcnt }| ).

    " CREATE 8 PARTICIPANTS
    
    DATA(first_names) = VALUE stringtab(
        ( |Sarah| ) ( |Leon| ) ( |Mara| ) ( |Tim| )
        ( |Clara| ) ( |Jan| ) ( |Sophie| ) ( |Eric| )
    ).

    DATA(last_names) = VALUE stringtab(
        ( |Fischer| ) ( |Kurz| ) ( |Lindner| ) ( |Seidel| )
        ( |Behrens| ) ( |Walter| ) ( |Krause| ) ( |Winter| )
    ).

    DO 8 TIMES.
      CLEAR ls_participant.

      ls_participant-client           = sy-mandt.
      ls_participant-participant_id   = |{ sy-index }|.
      ls_participant-first_name       = first_names[ sy-index ].
      ls_participant-last_name        = last_names[ sy-index ].
      ls_participant-email            = |{ to_lower( ls_participant-first_name ) }.{ to_lower( ls_participant-last_name ) }@example.com|.
      ls_participant-phone            = |+49 170 55{ sy-index }33{ sy-index }|.
      ls_participant-participant_uuid = cl_system_uuid=>create_uuid_x16_static( ).

      ls_participant-created_by       = 'GEN'.
      ls_participant-last_changed_by  = 'GEN'.
      GET TIME STAMP FIELD ls_participant-created_at.
      GET TIME STAMP FIELD ls_participant-last_changed_at.

      APPEND ls_participant TO lt_participants.
    ENDDO.

    INSERT zparticipant_4 FROM TABLE @lt_participants.
    out->write( |Inserted Participants: { sy-dbcnt }| ).

    " CREATE 8 REGISTRATIONS with FK links
    
    DO 8 TIMES.
      CLEAR ls_reg.

      ls_reg-client            = sy-mandt.
      ls_reg-registration_id   = |{ sy-index }|.
      ls_reg-registration_uuid = cl_system_uuid=>create_uuid_x16_static( ).

      ls_reg-event_uuid        = lt_events[ sy-index ]-event_uuid.
      ls_reg-participant_uuid  = lt_participants[ sy-index ]-participant_uuid.

      CASE sy-index.
        WHEN 1 OR 2 OR 7. ls_reg-status = 'Approved'.
        WHEN 4 OR 6 OR 8. ls_reg-status = 'New'.
        WHEN 3 OR 5.       ls_reg-status = 'Rejected'.
      ENDCASE.

      ls_reg-remarks           = |Registration|.
      ls_reg-created_by        = 'GEN'.
      ls_reg-last_changed_by   = 'GEN'.

      GET TIME STAMP FIELD ls_reg-created_at.
      GET TIME STAMP FIELD ls_reg-last_changed_at.

      APPEND ls_reg TO lt_regs.
    ENDDO.

    INSERT zregistration_4 FROM TABLE @lt_regs.
    out->write( |Inserted Registrations: { sy-dbcnt }| ).

  ENDMETHOD.
ENDCLASS.
