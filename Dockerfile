# FROM ubuntu:20.04

# RUN apt update && apt install python3 -y
# WORKDIR /app


# COPY requirements.txt requirements.txt
# COPY data_extraction.py data_extraction.py

# RUN python3 -m pip install -r requirements.txt



FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    g++ \
    unixodbc-dev \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    vim \
    telnet \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && apt-get install -y iproute2 && rm -rf /var/lib/apt/lists/*

# # 2. Install Microsoft ODBC Driver 18
# RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
#     && curl -fsSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#     && apt-get update \
#     && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
#     && rm -rf /var/lib/apt/lists/*

# Ensure prerequisites (curl, gnupg, lsb-release) are installed
RUN apt-get update && apt-get install -y curl gnupg lsb-release

# Execute the Microsoft ODBC 18 installation script
RUN bash -c 'set -e; \
    VERSION=$(grep VERSION_ID /etc/os-release | cut -d "\"" -f 2); \
    if ! [[ "18.04 20.04 22.04 24.04 25.10" == *"$VERSION"* ]]; then \
        echo "Ubuntu $VERSION is not currently supported."; \
        exit 1; \
    fi; \
    curl -sSL -O "https://packages.microsoft.com/config/ubuntu/$VERSION/packages-microsoft-prod.deb"; \
    dpkg -i packages-microsoft-prod.deb; \
    rm packages-microsoft-prod.deb; \
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev; \
    echo "export PATH=\"\$PATH:/opt/mssql-tools18/bin\"" >> /etc/bash.bashrc; \
    rm -rf /var/lib/apt/lists/*'

WORKDIR /app

# 3. Copy dependencies and install
COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt

# 4. Copy app code
COPY data_extraction.py data_extraction.py


CMD ["tail", "-f", "/dev/null"]