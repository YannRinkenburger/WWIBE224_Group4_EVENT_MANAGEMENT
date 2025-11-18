@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Participant'
@Metadata.allowExtensions: true
define root view entity ZI_ParticipantVH_4 
  as select from zparticipant_4
{
    @UI.hidden: true
    key participant_uuid as ParticipantUuid,
    @UI.lineItem: [{ position: 10, label: 'ID' }]
    participant_id as ParticipantId,
    @UI.lineItem: [{ position: 20, label: 'Full Name' }]
    concat_with_space(first_name, last_name, 1) as FullName
}
