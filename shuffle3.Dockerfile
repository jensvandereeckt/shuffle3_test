FROM bitnami/spark:latest

# Wissel naar root voor installaties
USER root

# Vereiste Python libraries installeren via requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Zet werkdirectory
WORKDIR /app

# Haal Python-script op van GitHub
RUN git clone https://github.com/jensvandereeckt/shuffle_1.git /app/code && \
    cp /app/code/count_votes.py .

# Zorg voor correcte rechten
RUN chmod -R 755 /app

# Service account mount je later bij run
CMD ["python", "count_votes.py"]
