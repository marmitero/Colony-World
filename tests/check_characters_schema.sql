BEGIN;
INSERT INTO accounts(id,auth_provider,auth_subject) VALUES
('00000000-0000-0000-0000-000000000001','test','left'),
('00000000-0000-0000-0000-000000000002','test','right');
INSERT INTO characters(id,account_id,slot,name) VALUES ('00000000-0000-0000-0000-000000000003','00000000-0000-0000-0000-000000000001',1,'Fixture');
INSERT INTO account_selected_character(account_id,character_id) VALUES ('00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000003');
DO $$
BEGIN
 BEGIN
  INSERT INTO account_selected_character(account_id,character_id) VALUES ('00000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000003');
  RAISE EXCEPTION 'cross-account selection allowed';
 EXCEPTION WHEN foreign_key_violation THEN NULL;
 END;
END $$;
ROLLBACK;
