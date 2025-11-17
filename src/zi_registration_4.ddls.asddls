@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_REGISTRATION_4
  as select from zregistration_4
{
    key registration_uuid as RegistrationUuid,
    registration_id as RegistrationId,
    event_uuid as EventUuid,
    participant_uuid as ParticipantUuid,
    status as Status,
    remarks as Remarks,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
    
}
