use customerdb;
CREATE ROLE IF NOT EXISTS app_admin;
CREATE ROLE IF NOT EXISTS app_poweruser;
CREATE ROLE IF NOT EXISTS app_user;
CREATE ROLE IF NOT EXISTS app_readonly;
CREATE ROLE IF NOT EXISTS app_auditor;

GRANT ALL PRIVILEGES ON customerdb.* TO app_admin;

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW, TRIGGER ON customerdb.* TO app_poweruser;

GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.Customer TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.Address TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.`Order` TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.OrderItem TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.Payment TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON customerdb.CustomerNote TO app_user;

GRANT SELECT, SHOW VIEW ON customerdb.* TO app_readonly;

GRANT SELECT, SHOW VIEW ON customerdb.* TO app_auditor;

-- REVOKE CREATE, ALTER, DROP, INDEX ON customerdb.* FROM app_poweruser, app_user, app_readonly, app_auditor;
-- REVOKKE on HOLD due to error in script. will review later in testing phase

CREATE USER IF NOT EXISTS 'svc_customerdb'@'%' IDENTIFIED BY 'ChangeMe_svc!';
CREATE USER IF NOT EXISTS 'u_admin'@'%'      IDENTIFIED BY 'ChangeMe_admin!';
CREATE USER IF NOT EXISTS 'u_power'@'%'      IDENTIFIED BY 'ChangeMe_power!';
CREATE USER IF NOT EXISTS 'u_app'@'%'        IDENTIFIED BY 'ChangeMe_app!';
CREATE USER IF NOT EXISTS 'u_read'@'%'       IDENTIFIED BY 'ChangeMe_read!';
CREATE USER IF NOT EXISTS 'u_audit'@'%'      IDENTIFIED BY 'ChangeMe_audit!';

GRANT app_admin TO 'u_admin'@'%';
GRANT app_poweruser TO 'u_power'@'%';
GRANT app_user TO 'u_app'@'%';
GRANT app_readonly TO 'u_read'@'%';
GRANT app_auditor TO 'u_audit'@'%';
GRANT app_user TO 'svc_customerdb'@'%';

SET DEFAULT ROLE app_admin TO 'u_admin'@'%';
SET DEFAULT ROLE app_poweruser TO 'u_power'@'%';
SET DEFAULT ROLE app_user TO 'u_app'@'%';
SET DEFAULT ROLE app_readonly TO 'u_read'@'%';
SET DEFAULT ROLE app_auditor TO 'u_audit'@'%';
SET DEFAULT ROLE app_user TO 'svc_customerdb'@'%';

DELIMITER //

CREATE PROCEDURE sp_add_customer(
IN p_first VARCHAR(80),
IN p_last VARCHAR(80),
IN p_email VARCHAR(80),
IN p_phone VARCHAR(25)
)
BEGIN
INSERT INTO Customer (FirstName, LastName, Email, Phone)
VALUES (p_first, p_last, p_email, p_phone);
END//
DELIMITER ;
 