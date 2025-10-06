create or replace view pigello_bolag as
select distinct
    "Bolag Stena" as "Bolagets id - customId",
    "Organisationsnummer Stena" as "Organisationsnummer - orgNo",
    "Ägare Stena" as "Bolagsnamn - name"
from stena_mappning
where "Nytt byggnadsnummer Stena" is not null;

create or replace view pigello_fastighet as
select
    stena_mappning.ExtFastighetsId,
    "Nytt KST Stena" as "Fastighetens id - customId",
    "Nytt KST Stena" || '-' || "Fastighetsbeteckning Stena" as "Fastighetsbeteckning - name",
    "Fastighetsbeteckning Stena" as "Populärnamn - popularName",
    "Ägare Stena"  as "Ägare - ownedBy",
    "Ägare Stena"  as "Hyresvärd - landlord",
    "Ägare Stena"  as "Aviserande Bolag - primaryFinancialHandler",
    "Stena Adress" as "Huvudsaklig adress - mainAddress"
from stena_mappning
where "Nytt byggnadsnummer Stena" is not null;

create or replace view pigello_byggnad as
select
    stena_mappning.ExtByggnadsId,
    stena_mappning.ExtFastighetsId,
    "Nytt byggnadsnummer Stena" as "Byggnadens id - customId",
    'Hyreshusbostad' as "Taxeringskategori - structureOperationType",
    "Byggnadsbeteckning Vitec" as "Namn - name",
    "Nytt KST Stena"::int || '-' || "Fastighetsbeteckning Stena" as "Fastighet - realestate",
    "Stena Adress" as "Adress - address",
    nämnare_pivot.BRA as "Bruksarea - registeredUsableArea",
    nämnare_pivot.ATemp as "Uppvärmd area - registeredTemperedArea"
from stena_mappning
left join nämnare_pivot on stena_mappning.ExtByggnadsId = nämnare_pivot.ExtByggnadsId
where "Nytt byggnadsnummer Stena" is not null;