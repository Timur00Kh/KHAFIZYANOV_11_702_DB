CREATE TABLE resource_2 (
  id bigserial,
  link text,
  tags integer[]
);

DO
$do$
declare rand integer;
declare ints integer ARRAY;
BEGIN
rand := random() * 100 + 50;

FOR i IN 1..1000000 LOOP

FOR i IN 1..rand LOOP
ints := array_append(ints, (random() * 400 + 1)::integer);
END LOOP;

INSERT INTO resource_2 (link, tags) values ('lol', ints);
ints:= null;
END LOOP;
END
$do$;


