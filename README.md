# DataExtractor-ElasticSearch

A containerized Python ETL pipeline for extracting data from SQL Server databases using Microsoft ODBC Driver 18 and preparing structured datasets for downstream search indexing and analytics[cite: 3, 4].

---

## Overview

This repository contains an isolated, Docker-based data extraction service designed to query enterprise SQL Server instances reliably across platforms[cite: 2, 3]. It handles container-to-host networking, environment-based configuration, secure database connections with SSL/TLS certificate handling, and automated dependency installation[cite: 1, 2, 3].

---

## Tech Stack

* **Language:** Python 3
* **Database Driver:** `pyodbc` with Microsoft ODBC Driver 18 for SQL Server[cite: 3, 4]
* **Environment Management:** `python-dotenv`[cite: 4]
* **Search / Ingestion:** `elasticsearch`[cite: 4]
* **Containerization:** Docker & Docker Compose[cite: 2, 3]

---

## Project Structure

```text
├── .env.example          # Environment variables template
├── .gitignore            # Git exclusion rules for secrets and caches
├── Dockerfile            # Ubuntu 20.04 container setup with ODBC 18 dependencies
├── docker-compose.yml    # Service orchestration and host networking config
├── data_extraction.py    # Main ETL extraction script
└── requirements.txt      # Python dependencies (pyodbc, elasticsearch, python-dotenv)
