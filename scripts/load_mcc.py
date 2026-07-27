import json
import os
from pathlib import Path
import psycopg2

# -----------------------------
# Database Connection
# Credentials are read from environment variables so they never
# need to be committed to the repo. Set them before running, e.g.:
#   set PGHOST=localhost
#   set PGDATABASE=finance_analytics
#   set PGUSER=postgres
#   set PGPASSWORD=your_password
# -----------------------------
conn = psycopg2.connect(
    host=os.environ.get("PGHOST", "localhost"),
    database=os.environ.get("PGDATABASE", "finance_analytics"),
    user=os.environ.get("PGUSER", "postgres"),
    password=os.environ["PGPASSWORD"]
)

cursor = conn.cursor()

# -----------------------------
# Read MCC JSON
# -----------------------------
json_path = Path("data/raw/mcc_codes.json")

with open(json_path, "r", encoding="utf-8") as file:
    mcc_data = json.load(file)

# -----------------------------
# Load dim_mcc
# -----------------------------
for mcc, description in mcc_data.items():
    cursor.execute(
        """
        INSERT INTO dim_mcc (mcc, description)
        VALUES (%s, %s)
        ON CONFLICT (mcc)
        DO NOTHING;
        """,
        (mcc, description)
    )

# -----------------------------
# Commit & Close
# -----------------------------
conn.commit()

cursor.close()
conn.close()

print(f"✅ Successfully loaded {len(mcc_data)} MCC codes into dim_mcc.")