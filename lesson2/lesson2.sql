--task1
CREATE OR REPLACE FUNCTION office_staff_counter() RETURNS TRIGGER AS $$
    BEGIN
        --
        -- Выполнить требуемую операцию в emp и добавить в emp_audit строку,
        -- отражающую эту операцию.
        --
        IF (TG_OP = 'DELETE') THEN
						update office SET emp_count = emp_count - 1 WHERE office.id = old.office_id;

            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE' AND NEW.office_id NOTNULL) THEN
						IF (OLD.office_id <> NEW.office_id) THEN
							update office SET emp_count = emp_count - 1 WHERE office.id = old.office_id;
							update office SET emp_count = emp_count + 1 WHERE office.id = NEW.office_id;
						END IF;

            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          	update office SET emp_count = emp_count + 1 WHERE office.id = NEW.office_id;

            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emp_audit
AFTER INSERT OR UPDATE OR DELETE ON emp
    FOR EACH ROW EXECUTE PROCEDURE office_staff_counter();

insert into office (name) VALUES ('super main office');
insert into office (name) VALUES ('second office');
insert into emp (name, office_id) VALUES ('first emp', 2);
insert into emp (name, office_id) VALUES ('sec emp', 2);
delete from emp where id = 1;

update emp set office_id = 3 where emp.id = 5;

delete from emp where emp.id = 3;

--task2
CREATE OR REPLACE FUNCTION create_year_table(y int) RETURNS boolean AS $$
DECLARE i integer;
BEGIN
  EXECUTE 'CREATE TABLE weather_' || y || '(
  day integer,
  temperature integer
);';

  i:=1;
  LOOP
    EXECUTE 'INSERT into weather_' || y || ' VALUES (' || i ||', (random()*(40-0)+0)::integer);';
    i:= i + 1;
    EXIT WHEN i > 366;  -- аналогично предыдущему примеру
END LOOP;

  return true;
end;
$$ LANGUAGE plpgsql;


SELECT create_year_table(1984);

CREATE OR REPLACE FUNCTION averageTemperature(y integer) RETURNS table(avg numeric) AS $$
BEGIN
    return query EXECUTE 'SELECT avg(temperature) FROM weather_' || $1 || ';';
end;
$$ LANGUAGE plpgsql;

SELECT avg(temperature) FROM weather_1984;
SELECT averageTemperature(1984);
select tablename from pg_tables where schemaname = 'public' and tablename = '';

--task3
CREATE OR REPLACE FUNCTION averageTemperature(y1 integer, y2 integer) RETURNS numeric AS $$
DECLARE
  avg_temp numeric;
  i integer;
BEGIN
  i:=y1;
  LOOP
    IF EXISTS(select 1 from pg_tables where schemaname = 'public' and tablename = 'weather_' || i) then
      IF avg_temp ISNULL then
        avg_temp:= (SELECT averageTemperature(i))::numeric;
      ELSE
        avg_temp:= (avg_temp + (SELECT averageTemperature(i)))::numeric / 2;
      end if;
    end if;
    i:= i + 1;
    EXIT WHEN i = y2;
  end loop;
  return avg_temp;
end;
$$ LANGUAGE plpgsql;

SELECT averageTemperature(1980, 1990);
SELECT create_year_table(1987);
