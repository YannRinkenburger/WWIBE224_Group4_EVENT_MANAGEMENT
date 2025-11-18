@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Text for Event'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_EventStatusText as select from zevent_4
{
    key event_uuid,
        status,
    
        case status
            when 'P' then 'Planned'
            when 'O' then 'Open'
            when 'C' then 'Closed'
            else 'Not definied'
        end as status_text
}
