@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_EVENT_4 
  as select from zevent_4
{
    key event_uuid as EventUuid,
    event_id as EventId,
    title as Title,
    location as Location,
    start_date as StartDate,
    end_date as EndDate,
    max_participants as MaxParticipants,
    status as Status,
    description as Description,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
}
