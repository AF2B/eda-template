FROM clojure:temurin-17-tools-deps

WORKDIR /app

COPY deps.edn .
RUN clojure -P

COPY . .

CMD ["clojure", "-M:run"]