-- Training data intentionally includes defects. Foreign-key enforcement is
-- disabled only while loading this controlled lab dataset.
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

INSERT INTO teams VALUES
(1, 'Application Support'),
(2, 'Finance Systems'),
(3, 'Service Desk');

INSERT INTO users VALUES
(101, 'Aisha Rahman', 'aisha.rahman@example.com', 'active', 1, '2026-01-08 09:00:00'),
(102, 'Ben Carter', 'ben.carter@example.com', 'active', 1, '2026-01-10 09:00:00'),
(103, 'Chloe Evans', 'chloe.evans@example.com', 'suspended', 1, '2026-01-11 09:00:00'),
(104, 'Daniel Wong', 'daniel.wong@example.com', 'active', 2, '2026-01-12 09:00:00'),
(105, 'Emma Lewis', 'emma.lewis@example.com', 'active', 3, '2026-01-13 09:00:00'),
(106, 'Daniel W.', '  DANIEL.WONG@example.com  ', 'active', 2, '2026-09-15 14:30:00'),
(107, 'Farah Ali', 'farah.ali@example.com', 'active', 1, '2026-02-01 09:00:00');

INSERT INTO roles VALUES
(1, 'Administrator'),
(2, 'Support Agent'),
(3, 'Read Only');

INSERT INTO permissions VALUES
(1, 'case.view', 'View support cases'),
(2, 'case.edit', 'Edit support cases'),
(3, 'case.close', 'Close support cases'),
(4, 'user.manage', 'Create and change users'),
(5, 'audit.export', 'Export audit history');

INSERT INTO user_roles VALUES
(1, 101, 1, '2026-01-08 10:00:00', 101),
(2, 102, 2, '2026-01-10 10:00:00', 101),
(3, 103, 1, '2026-01-11 10:00:00', 101), -- defect: suspended administrator
(4, 104, 3, '2026-01-12 10:00:00', 101),
(5, 105, 3, '2026-01-13 10:00:00', 101),
(6, 107, 2, '2026-02-01 10:00:00', 101);

INSERT INTO role_permissions VALUES
(1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4), (5, 1, 5),
(6, 2, 1), (7, 2, 2), (8, 2, 3),
(9, 3, 1);

INSERT INTO case_statuses VALUES
('open', 'Open', 0),
('in_progress', 'In Progress', 0),
('pending', 'Pending Customer', 0),
('resolved', 'Resolved', 1),
('closed', 'Closed', 1);

INSERT INTO cases VALUES
(1001, 'SSO login loop', 'User returns to sign-in after successful authentication.', 'high', 'open', 105, 102, '2026-09-28 08:20:00', '2026-09-28 08:20:00', NULL),
(1002, 'Finance export times out', 'Month-end CSV export times out after 60 seconds.', 'critical', 'in_progress', 104, 107, '2026-09-29 10:15:00', '2026-10-01 13:40:00', NULL),
(1003, 'Password reset email missing', 'No reset email received after three attempts.', 'medium', 'open', 105, 999, '2026-09-30 11:00:00', '2026-09-30 11:00:00', NULL), -- defect: missing assignee
(1004, 'Duplicate charge displayed', 'Portal shows the same invoice charge twice.', 'high', 'closed', 104, 102, '2026-09-21 09:30:00', '2026-09-25 16:00:00', NULL), -- defect: no resolved_at
(1005, 'Mobile session expires early', 'Session ends after five minutes instead of thirty.', 'medium', 'waiting_customer', 105, 107, '2026-10-01 12:00:00', '2026-10-02 09:15:00', NULL), -- defect: invalid status
(1006, 'Audit export missing actor', 'One audit row has no named actor.', 'low', 'resolved', 101, 102, '2026-09-18 14:00:00', '2026-09-19 10:00:00', '2026-09-19 10:00:00'),
(1007, 'Cannot update profile', 'Save button returns a validation error.', 'medium', 'pending', 106, 102, '2026-10-02 14:00:00', '2026-10-03 09:00:00', NULL),
(1008, 'Dashboard widget blank', 'The SLA widget loads without values.', 'low', 'resolved', 105, 107, '2026-09-22 08:00:00', '2026-09-23 11:20:00', '2026-09-23 11:20:00');

INSERT INTO audit_history VALUES
(5001, 1001, 105, 'CASE_CREATED', NULL, 'open', '2026-09-28 08:20:00', 'Created through self service.'),
(5002, 1001, 101, 'ASSIGNED', NULL, '102', '2026-09-28 08:30:00', 'Assigned to Ben Carter.'),
(5003, 1002, 104, 'CASE_CREATED', NULL, 'open', '2026-09-29 10:15:00', NULL),
(5004, 1002, 107, 'STATUS_CHANGED', 'open', 'in_progress', '2026-09-29 10:45:00', 'Reproduced against month-end dataset.'),
(5005, 1003, 105, 'CASE_CREATED', NULL, 'open', '2026-09-30 11:00:00', NULL),
(5006, 1003, 101, 'ASSIGNED', NULL, '999', '2026-09-30 11:05:00', 'Import referenced retired agent ID.'),
(5007, 1004, 104, 'CASE_CREATED', NULL, 'open', '2026-09-21 09:30:00', NULL),
(5008, 1004, 102, 'STATUS_CHANGED', 'resolved', 'closed', '2026-09-25 16:00:00', 'Closed by batch job; timestamp not copied.'),
(5009, 1005, 105, 'CASE_CREATED', NULL, 'open', '2026-10-01 12:00:00', NULL),
(5010, 1005, 107, 'STATUS_CHANGED', 'in_progress', 'waiting_customer', '2026-10-02 09:15:00', 'Legacy integration used obsolete status.'),
(5011, 1006, 101, 'CASE_CREATED', NULL, 'open', '2026-09-18 14:00:00', NULL),
(5012, 1006, NULL, 'STATUS_CHANGED', 'in_progress', 'resolved', '2026-09-19 10:00:00', 'Automated workflow action.'),
(5013, 1007, 106, 'CASE_CREATED', NULL, 'open', '2026-10-02 14:00:00', NULL),
(5014, 1007, 102, 'STATUS_CHANGED', 'in_progress', 'pending', '2026-10-03 09:00:00', 'Requested browser console log.'),
(5015, 1008, 105, 'CASE_CREATED', NULL, 'open', '2026-09-22 08:00:00', NULL),
(5016, 1008, 107, 'STATUS_CHANGED', 'in_progress', 'resolved', '2026-09-23 11:20:00', 'Cache refresh restored data.');

COMMIT;
PRAGMA foreign_keys = ON;
