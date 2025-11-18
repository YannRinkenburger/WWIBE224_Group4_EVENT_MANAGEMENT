@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_REGISTRATION_4 
  as projection on ZR_Registration_4
{
    key RegistrationUuid,
    RegistrationId,
    EventUuid,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ParticipantVH_4', element: 'ParticipantUuid' } }]
    @ObjectModel.text.element: ['FullName']
    ParticipantUuid,
    Status,
    Remarks,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _ParticipantText.FullName as FullName,
    
    /* Associations */
    _Event : redirected to parent ZC_EventTP_4,
    _Participant
    
}
