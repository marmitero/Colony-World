BEGIN;
INSERT INTO accounts(id, auth_provider, auth_subject) VALUES ('00000000-0000-0000-0000-000000000001','test','fixture');
INSERT INTO characters(id,account_id,slot,name)
SELECT ('00000000-0000-0000-0000-00000000000'||(n+1)::text)::uuid,'00000000-0000-0000-0000-000000000001',n,'Fixture'||n FROM generate_series(1,5) n;
DO $$
BEGIN
  BEGIN
    INSERT INTO characters(id,account_id,slot,name) VALUES ('00000000-0000-0000-0000-000000000009','00000000-0000-0000-0000-000000000001',6,'Sixth');
    RAISE EXCEPTION 'sixth slot allowed';
  EXCEPTION WHEN check_violation THEN NULL;
  END;
  BEGIN
    INSERT INTO characters(id,account_id,slot,name) VALUES ('00000000-0000-0000-0000-000000000009','00000000-0000-0000-0000-000000000001',1,'DuplicateSlot');
    RAISE EXCEPTION 'duplicate slot allowed';
  EXCEPTION WHEN unique_violation THEN NULL;
  END;
  IF (SELECT count(*) FROM characters WHERE account_id='00000000-0000-0000-0000-000000000001') <> 5 THEN RAISE EXCEPTION 'invalid count'; END IF;
END $$;
ROLLBACK;
