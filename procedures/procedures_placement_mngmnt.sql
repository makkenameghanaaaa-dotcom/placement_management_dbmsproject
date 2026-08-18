USE placement_management;

DELIMITER $$
CREATE PROCEDURE get_eligible_companies(IN p_reg_no VARCHAR(20))
BEGIN
    SELECT c.company_name,
           jr.role_name,
           jp.salary,
           jp.minimum_cgpa,
           jp.application_deadline,
           a.status AS application_status,
           o.status AS offer_status
    FROM student s
    JOIN job_posting_branch jpb ON jpb.branch = s.branch
    JOIN job_posting jp ON jp.company_role_id = jpb.company_role_id
    JOIN company c ON c.company_id = jp.company_id
    JOIN job_role jr ON jr.role_id = jp.role_id
    LEFT JOIN application a
           ON a.company_role_id = jp.company_role_id
          AND a.reg_no = s.reg_no
    LEFT JOIN offer o
           ON o.application_id = a.application_id
    WHERE s.reg_no = p_reg_no
      AND s.cgpa >= jp.minimum_cgpa
      AND jp.application_deadline >= CURDATE();
END$$
DELIMITER ;

CALL get_eligible_companies('23BCE9988');


DELIMITER $$
CREATE PROCEDURE get_student_oa_status(IN p_reg_no VARCHAR(20))
BEGIN
    SELECT c.company_name,
           jr.role_name,
           os.scheduled_at,
           oa.duration_minutes,
           os.score,
           os.result
    FROM application a
    JOIN oa_schedule os ON os.application_id = a.application_id
    JOIN oa ON oa.oa_id = os.oa_id
    JOIN job_posting jp ON jp.company_role_id = a.company_role_id
    JOIN company c ON c.company_id = jp.company_id
    JOIN job_role jr ON jr.role_id = jp.role_id
    WHERE a.reg_no = p_reg_no;
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE get_student_interview_status(IN p_reg_no VARCHAR(20))
BEGIN
    SELECT c.company_name,
           jr.role_name,
           i.round_name,
           is1.scheduled_at,
           is1.result
    FROM application a
    JOIN interview_schedule is1 ON is1.application_id = a.application_id
    JOIN interview i ON i.interview_id = is1.interview_id
    JOIN job_posting jp ON jp.company_role_id = a.company_role_id
    JOIN company c ON c.company_id = jp.company_id
    JOIN job_role jr ON jr.role_id = jp.role_id
    WHERE a.reg_no = p_reg_no;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE get_student_offers(IN p_reg_no VARCHAR(20))
BEGIN
    SELECT c.company_name,
           jr.role_name,
           o.offer_date,
           o.ctc,
           o.status
    FROM application a
    JOIN offer o ON o.application_id = a.application_id
    JOIN job_posting jp ON jp.company_role_id = a.company_role_id
    JOIN company c ON c.company_id = jp.company_id
    JOIN job_role jr ON jr.role_id = jp.role_id
    WHERE a.reg_no = p_reg_no;
END$$
DELIMITER ;
