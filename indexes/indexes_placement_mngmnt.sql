USE placement_management;

CREATE INDEX idx_application_regno ON application(reg_no);
CREATE INDEX idx_application_role ON application(company_role_id);
CREATE INDEX idx_jobposting_company ON job_posting(company_id);
CREATE INDEX idx_offer_ctc ON offer(ctc);
CREATE INDEX idx_student_branch_cgpa ON student(branch, cgpa);