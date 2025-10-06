

create or replace view enheter_with_typ as
select
    Enheter.ExtEnhetsId,
    Enheter.ExtEnhetstypId,
    Enheter.ExtObjektId,
    Enhetstyper.Namn,
    Enheter.Area
from Enheter left join Enhetstyper on Enheter.ExtEnhetstypId = Enhetstyper.ExtEnhetstypId;

create or replace view enheter_pivot as
PIVOT enheter_with_typ
ON Namn in (
'Sovrum 2',
'Inre hall',
'Matrum/matsal',
'Bastu',
'Hiss',
'Fläktrum',
'Kök',
'Sovrum 1',
'Vardagsrum',
'Städförråd',
'Lokal',
'Ventilation',
'Hall',
'Mangelrum',
'Trapphus',
'Yttre rum',
'Cykelrum',
'Hissmaskinrum',
'Badrum',
'Toalett',
'Förråd',
'Sovrum 3',
'Vindsgång',
'Uteplats',
'Tvättstuga',
'Elrum',
'Klädkammare',
'Kokvrå',
'Balkong',
'Källarförråd',
'Källargång',
'Undercentral',
'Övrigt',
'Klädkammare hobbyrum',
'Badrum 2',
'Lägenheten',
'Vindsförråd',
'Sovrum 4',
'Balkong 2',
'Torkrum',
'Soprum'

)
USING first(Area);

