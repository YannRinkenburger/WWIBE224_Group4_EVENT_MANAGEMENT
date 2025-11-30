@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Projection View'
@ObjectModel.semanticKey: [ 'EventId' ]
@Metadata.allowExtensions: true
define root view entity ZC_EventTP_4 
  provider contract transactional_query
  as projection on ZR_EVENTTP_4
{
    key EventUuid,
    EventId,
    Title,
    Location,
    StartDate,
    EndDate,
    MaxParticipants,
    Status,
    _StatusText.status_text as StatusText,
    Description,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _Registrations : redirected to composition child ZC_REGISTRATION_4
    
    
}
