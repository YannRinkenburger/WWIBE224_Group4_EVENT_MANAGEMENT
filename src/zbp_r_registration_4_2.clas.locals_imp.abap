CLASS lhc_ZR_REGISTRATION_4_2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_registration_4_2 RESULT result.

    METHODS ApproveRegistration FOR MODIFY
      IMPORTING keys FOR ACTION zr_registration_4_2~ApproveRegistration RESULT result.

    METHODS RejectRegistration FOR MODIFY
      IMPORTING keys FOR ACTION zr_registration_4_2~RejectRegistration RESULT result.

ENDCLASS.

CLASS lhc_ZR_REGISTRATION_4_2 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD ApproveRegistration.
    DATA message TYPE REF TO zcm_registration_4.

    READ ENTITY IN LOCAL MODE zr_registration_4_2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations REFERENCE INTO DATA(registration).
      IF registration->Status = 'Approved'.
        message = NEW zcm_registration_4( textid      = zcm_registration_4=>already_approved ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration_4_2.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration_4_2.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      IF registration->Status = 'Rejected'.
        message = NEW zcm_registration_4( textid      = zcm_registration_4=>already_rejected ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration_4_2.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration_4_2.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      registration->Status = 'Approved'.
      message = NEW zcm_registration_4( severity    = if_abap_behv_message=>severity-success
                                textid      = zcm_registration_4=>approve_success ).
      APPEND VALUE #( %tky     = registration->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-zr_registration_4_2.
    ENDLOOP.

    " Modify Data
    MODIFY ENTITY IN LOCAL MODE zr_registration_4_2
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN registrations
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN registrations
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD RejectRegistration.
    DATA message TYPE REF TO zcm_registration_4.

    READ ENTITY IN LOCAL MODE zr_registration_4_2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations REFERENCE INTO DATA(registration).
      IF registration->Status = 'Approved'.
        message = NEW zcm_registration_4( textid      = zcm_registration_4=>already_approved ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration_4_2.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration_4_2.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      IF registration->Status = 'Rejected'.
        message = NEW zcm_registration_4( textid      = zcm_registration_4=>already_rejected ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration_4_2.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration_4_2.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      registration->Status = 'Rejected'.
      message = NEW zcm_registration_4( severity    = if_abap_behv_message=>severity-success
                                textid      = zcm_registration_4=>reject_success ).
      APPEND VALUE #( %tky     = registration->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-zr_registration_4_2.
    ENDLOOP.

    " Modify Data
    MODIFY ENTITY IN LOCAL MODE zr_registration_4_2
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN registrations
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN registrations
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

ENDCLASS.
