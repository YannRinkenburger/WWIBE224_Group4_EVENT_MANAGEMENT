@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Base View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_Registration_4 
  as select from ZI_REGISTRATION_4  
    association to parent ZR_EVENTTP_4 as _Event on $projection.EventUuid = _Event.EventUuid
    association to ZR_ParticipantTP_4 as _Participant on $projection.ParticipantUuid = _Participant.ParticipantUuid
    association [1..1] to ZI_ParticipantVH_4 as _ParticipantText on $projection.ParticipantUuid = _ParticipantText.ParticipantUuid
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
    LastChangedAt,
    
    _Event,
    _Participant,
    _ParticipantText
    
}
