FROM bitnami/spark:latest

# Ga naar root user om extra Python libraries te kunnen installeren
USER root

# Installeer extra Python packages voor Google Drive API
RUN pip install --no-cache-dir \
    google-api-python-client \
    google-auth \
    google-auth-httplib2 \
    google-auth-oauthlib

# Zet werkdirectory
WORKDIR /app

# Kopieer het script vanop GitHub (of plaats handmatig met COPY als alternatief)
RUN git clone https://github.com/jensvandereeckt/shuffle_1.git /app/code && \
    cp /app/code/count_votes.py .

# Geef werkdirectory de juiste rechten (voor latere mounting of loggen)
RUN chmod -R 755 /app

# Service-account bestand mount je extern bij het runnen van Docker
CMD ["python", "count_votes.py"]
