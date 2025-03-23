set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_user_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
insert into public.users (id, email, name, username)
values (new.id,
        new.email,
        new.raw_user_meta_data ->> 'name',
        new.raw_user_meta_data ->> 'username') on conflict (id)
    do
update set
    email = excluded.email,
    name = excluded.name,
    username = excluded.username;

return new;
end;
$function$
;