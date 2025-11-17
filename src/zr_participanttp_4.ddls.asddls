@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participant Base View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_ParticipantTP_4 
  as select from ZI_Participant_4
{
    key ParticipantUuid,
    ParticipantId,
    FirstName,
    LastName,
    Email,
    Phone,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
    
}
