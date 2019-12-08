CREATE TABLE Call (
  id BIGSERIAL not null,
  time timestamp,
  number VARCHAR(15)
);

CREATE OR REPLACE FUNCTION create_call_table(t timestamp) RETURNS boolean AS $$
begin
  EXECUTE 'CREATE TABLE IF NOT EXISTS Call_' || (SELECT EXTRACT(MINUTE FROM t)) ||' () INHERITS (Call);';
  return true;
end;
$$ LANGUAGE plpgsql;

SELECT create_call_table(now()::timestamp);
SELECT 'loox' || (SELECT EXTRACT(MINUTE FROM TIMESTAMP '2001-02-16 20:38:40'));
insert into call_38 (time, number) VALUES (now()::timestamp, '+790334565432');

CREATE OR REPLACE FUNCTION on_call_upd() RETURNS TRIGGER AS $$
begin
  IF (TG_OP = 'INSERT') THEN
    IF NOT EXISTS(select 1 from pg_tables where schemaname = 'public' and tablename = 'call_' || (SELECT EXTRACT(MINUTE FROM NEW.time))) then
      PERFORM create_call_table(NEW.time::timestamp);
    end if;
    EXECUTE format('INSERT INTO call_' || (SELECT EXTRACT(MINUTE FROM NEW.time)) || ' (time, number) VALUES ($1, $2)') using NEW.time, NEW.number;
    return null;
  ELSIF (TG_OP = 'UPDATE') THEN
    return NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    return OLD;
end if;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER call_audit
AFTER INSERT OR UPDATE OR DELETE ON call
    FOR EACH ROW EXECUTE PROCEDURE on_call_upd();

INSERT INTO call (time, number) VALUES (now()::timestamp, '+12345675432');

CREATE TABLE IF NOT EXISTS Call2 () INHERITS (Call);











