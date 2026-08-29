import os
import pyodbc
from dotenv import load_dotenv

load_dotenv()

# Read parameters from environment variables with fallback defaults
server = os.getenv("SQL_SERVER", r"host.docker.internal\SQLEXPRESS")
database = os.getenv("SQL_DATABASE", "AdventureWorksDW2022")
username = os.getenv("SQL_USERNAME", "elastic")
password = os.getenv("SQL_PASSWORD", "1234")
driver = os.getenv("SQL_DRIVER", "{ODBC Driver 18 for SQL Server}")

conn_parts = [
    f"DRIVER={driver}",
    f"SERVER={server},1433" if ",1433" not in server else f"SERVER={server}",
    f"DATABASE={database}",
]

if username and password:
    conn_parts.extend([f"UID={username}", f"PWD={password}"])
else:
    conn_parts.append("Trusted_Connection=yes")

conn_str = ";".join(conn_parts) + ";TrustServerCertificate=yes;Encrypt=optional;"

try:
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    print("Successfully connected to SQL Server!")

    cursor.execute("SELECT TOP 5 * FROM dbo.DimDate;")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

except Exception as e:
    print(f"Error connecting to database: {e}")

finally:
    if "conn" in locals() and conn:
        conn.close()