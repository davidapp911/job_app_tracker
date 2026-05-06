# Job Application Tracker

A command-line tool for tracking and managing job applications, backed by a local SQLite database. Built with a clean layered architecture: CLI → API → Data Utilities → Database.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Python 3.14 |
| CLI | [Typer](https://typer.tiangolo.com/) |
| ORM | SQLAlchemy 2.0 |
| Database | SQLite (`~/.jobs/job.db`) |
| Display | Tabulate |
| Linting | Ruff + Black |
| Testing | pytest |

---

## Installation

**Requirements:** [pyenv](https://github.com/pyenv/pyenv) with Python 3.14 installed.

1. Clone the repository:

```bash
git clone <repo-url>
cd job_application_tracker
```

2. Run the install script:

```bash
bash install.sh
```

This will:
- Install the `japp` command globally via pip
- Add the pyenv bin directory to your `PATH` in `~/.zshrc` (only once)

3. Open a new terminal — `japp` is now available from anywhere.

> The database is stored at `~/.jobs/job.db` and persists across reinstalls.

---

## Usage

```bash
japp [COMMAND] [OPTIONS]
```

---

## Commands

### Add a new entry

```bash
japp add "Google" "Software Engineer"
```

### List all entries

```bash
japp list
```

### Search entries

Filter by any combination of fields:

```bash
japp search-by --company "Google"
japp search-by --id 1
japp search-by --job_title "Engineer"
japp search-by --status "Pending start"
japp search-by --company "Google" --job_title "Engineer"
```

### Update an entry

Pass one or more fields to update by entry ID:

```bash
japp update 1 --company "Amazon"
japp update 1 --job_title "Senior Engineer" --status "Applied"
```

### Delete an entry

```bash
japp delete 1
```

### Reset the database

Deletes all entries (prompts for confirmation):

```bash
japp reset
```

---

## Data Model

Each job application entry stores:

| Field | Type | Required | Default |
|-------|------|----------|---------|
| `id` | Integer (auto) | — | — |
| `company` | String (max 30) | Yes | — |
| `job_title` | String (max 30) | Yes | — |
| `status` | String (max 30) | No | `"Pending start"` |

---

## Testing

Tests are split across two layers:

- **API tests** (`tests/test_api.py`) — run against a real in-memory SQLite database; validate business logic and persistence.
- **CLI tests** (`tests/test_cli.py`) — use `typer.testing.CliRunner` with a mocked API layer; validate command wiring and output.
- **Data utility tests** (`tests/test_data_utils.py`) — unit tests for `filter_empty_fields`.

```bash
# Run all tests
pytest

# Run API layer by CRUD category
pytest -m create
pytest -m read
pytest -m update
pytest -m delete

# Run data utility tests
pytest -m data_utils

# Run CLI tests by command
pytest -m cli_add
pytest -m cli_list
pytest -m cli_search_by
pytest -m cli_update
pytest -m cli_delete
pytest -m cli_reset
```

Available markers (defined in `pytest.ini`): `create`, `read`, `update`, `delete`, `data_utils`, `cli_add`, `cli_list`, `cli_search_by`, `cli_update`, `cli_delete`, `cli_reset`.

---

## License

This project is for learning and personal use.
