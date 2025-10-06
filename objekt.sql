create or replace view object_base as

select
    Objekt.Nr as "Objektets id - customId",
    Objekt.Lägenhetsnummer as "Lägenhetsnummer",
    Objektstyper.Namn as "Kategori - category",
    pigello_byggnad."Namn - name" as "Byggnad - building",
    '' as "Parkeringsområde - parkingLot",
    '' as "Utomhusområde - outdoorArea",
    Objekt.Våning as "Våningar - floors",
    Objekt.Postadress || ', ' || Objekt.Postnr || ', ' ||  Objekt.Ort || ', Sverige' as "Adress - address",
    nämnare_pivot.Objektsarea as "Boarea (BOA) - usableArea",
    nämnare_pivot.Objektsarea as "Lokalarea (LOA) - usableArea",
    nämnare_pivot.Objektsarea as "Parkeringsarea - usableArea",
    coalesce(Objekt.Postadress, '') || ' (' || Objekt.Nr || ')'|| coalesce(' (' || Objekt.Namn || ')', '') as "Populärnamn - popularName",
    Objekt.Anteckning as "Anteckningar - note",
    Objektstyper.Namn as objektstyp,
    Objektsgrupp.Namn as objektsgrupp,
    Byggnad.Nr as källfelts_byggnads_nr,
    Byggnad.Namn as källfelts_byggnads_namn,
    fastighet_objekt.Nr as källfelts_fastighet_objekt_nr,
    fastighet_objekt.Namn as källfelts_fastighet_objekt_namn,
    fastighet_byggnad.Nr as källfelts_fastighet_byggnad_nr,
    fastighet_byggnad.Namn as källfelts_fastighet_byggnad_namn,
    ObjektFrom::date as ObjektFrom,
    ObjektTom::date as ObjektTom,
    1 as test
from
    Objekt
left join Objektstyper on Objekt.ExtObjektstypId = Objektstyper.ExtObjektstypId
left join Objektsgrupp on Objektstyper.ExtObjektsgruppId = Objektsgrupp.ExtObjektsgruppId
left join Byggnad on Objekt.ExtByggnadsId = Byggnad.ExtByggnadsId
left join Fastighet fastighet_byggnad on Byggnad.ExtFastighetsId = fastighet_byggnad.ExtFastighetsId
left join Fastighet fastighet_objekt on Objekt.ExtFastighetsId = fastighet_objekt.ExtFastighetsId
left join nämnare_pivot on Objekt.ExtObjektId = nämnare_pivot.ExtObjektId
left join pigello_byggnad on Objekt.ExtByggnadsId = pigello_byggnad.ExtByggnadsId
left join pigello_fastighet on Objekt.ExtFastighetsId = pigello_fastighet.ExtFastighetsId
left join stena_mappning stena_mappning_fastighet on Objekt.ExtFastighetsId = stena_mappning_fastighet.ExtFastighetsId
where current_date between coalesce(ObjektFrom::date, current_date) and coalesce(ObjektTom::date, current_date)
;

create or replace view pigello_lägenheter as
select * from object_base where objektsgrupp = 'Bostad';

create or replace view pigello_lokaler as
select * from object_base where objektsgrupp = 'Lokal';

create or replace view pigello_fordonsplatser as
select * from object_base where objektsgrupp in ('Park.plats', 'Garage');

create or replace view pigello_utomhussektioner as
select * from object_base where objektsgrupp = 'Övrigt hyresobj.';

create or replace view pigello_ej_uthyrningsbart_objekt as
select * from object_base where objektsgrupp = 'Ej uthyrningsbara objekt';