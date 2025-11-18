@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Base View for App 2'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_REGISTRATION_4_2 
  as select from ZI_REGISTRATION_4
{
    key RegistrationUuid,
    RegistrationId,
    EventUuid,
    ParticipantUuid,
    Status,
    Remarks,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
