PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS audit_history;
DROP TABLE IF EXISTS cases;
DROP TABLE IF EXISTS case_statuses;
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
    team_id     INTEGER PRIMARY KEY,
    team_name   TEXT NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY,
    full_name     TEXT NOT NULL,
    email         TEXT NOT NULL,
    account_status TEXT NOT NULL CHECK (account_status IN ('active', 'suspended', 'disabled')),
    team_id       INTEGER,
    created_at    TEXT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE roles (
    role_id     INTEGER PRIMARY KEY,
    role_name   TEXT NOT NULL UNIQUE
);

CREATE TABLE permissions (
    permission_id    INTEGER PRIMARY KEY,
    permission_code  TEXT NOT NULL UNIQUE,
    description      TEXT NOT NULL
);

CREATE TABLE user_roles (
    user_role_id INTEGER PRIMARY KEY,
    user_id      INTEGER NOT NULL,
    role_id      INTEGER NOT NULL,
    granted_at   TEXT NOT NULL,
    granted_by   INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (granted_by) REFERENCES users(user_id)
);

CREATE TABLE role_permissions (
    role_permission_id INTEGER PRIMARY KEY,
    role_id             INTEGER NOT NULL,
    permission_id       INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

CREATE TABLE case_statuses (
    status_code   TEXT PRIMARY KEY,
    display_name  TEXT NOT NULL,
    is_terminal   INTEGER NOT NULL CHECK (is_terminal IN (0, 1))
);

CREATE TABLE cases (
    case_id          INTEGER PRIMARY KEY,
    title            TEXT NOT NULL,
    description      TEXT NOT NULL,
    priority         TEXT NOT NULL CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    status           TEXT NOT NULL,
    requester_id     INTEGER NOT NULL,
    assigned_user_id INTEGER,
    created_at       TEXT NOT NULL,
    updated_at       TEXT NOT NULL,
    resolved_at      TEXT,
    FOREIGN KEY (status) REFERENCES case_statuses(status_code),
    FOREIGN KEY (requester_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_user_id) REFERENCES users(user_id)
);

CREATE TABLE audit_history (
    audit_id     INTEGER PRIMARY KEY,
    case_id      INTEGER NOT NULL,
    actor_id     INTEGER,
    action_type  TEXT NOT NULL,
    old_value    TEXT,
    new_value    TEXT,
    action_at    TEXT NOT NULL,
    note         TEXT,
    FOREIGN KEY (case_id) REFERENCES cases(case_id),
    FOREIGN KEY (actor_id) REFERENCES users(user_id)
);

CREATE INDEX idx_users_team ON users(team_id);
CREATE INDEX idx_cases_status ON cases(status);
CREATE INDEX idx_cases_assignee ON cases(assigned_user_id);
CREATE INDEX idx_cases_requester ON cases(requester_id);
CREATE INDEX idx_audit_case_time ON audit_history(case_id, action_at);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
