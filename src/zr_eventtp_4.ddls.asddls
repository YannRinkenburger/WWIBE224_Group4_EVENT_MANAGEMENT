@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Base View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_EVENTTP_4 
  as select from ZI_EVENT_4
{
    key EventUuid,
    EventId,
    Title,
    Location,
    StartDate,
    EndDate,
    MaxParticipants,
    Status,
    Description,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
