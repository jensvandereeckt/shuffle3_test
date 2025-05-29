FROM bitnami/spark:latest

# Schakel over naar root om extra tools te installeren
USER root

# Zet werkdirectory
WORKDIR /app

# Installeer Google Drive dependencies in stappen om geheugenproblemen te vermijden
ENV PIP_NO_PROGRESS_BAR=off

# Vereiste pakketten apart installeren (verdeeld om memory te besparen)
ENV PIP_PROGRESS_BAR=off
RUN pip install --no-cache-dir --disable-pip-version-check --no-input google-api-python-client google-auth

# Vereistenbestand kopiëren (als je meer wil toevoegen)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Code klonen van GitHub (je mag dit vervangen met COPY als je lokaal werkt)
# Zet veilige flags uit enkel voor deze build-stap
RUN apt-get update -o Acquire::Check-Valid-Until=false \
 && apt-get install -y --no-install-recommends git \
 || true
RUN git clone https://github.com/jensvandereeckt/shuffle3_test.git /app/code && \
    cp /app/code/count_votes.py .

# Zorg voor voldoende rechten (voor logging of mount)
RUN chmod -R 755 /app

# Service account mount je extern bij run
CMD ["python", "count_votes.py"]
