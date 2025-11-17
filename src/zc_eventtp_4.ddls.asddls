@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Projection View'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_EventTP_4 
  as select from ZR_EVENTTP_4
{
    key EventUuid,
    EventId,
    Title,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    Location,
    StartDate,
    EndDate,
    MaxParticipants,
    Status,
    case Status
      when 'P' then 'Planned'
      when 'O' then 'Open'
      when 'C' then 'Closed'
      else 'Not found'
    end as StatusText,
    Description,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _Registrations
    
}
