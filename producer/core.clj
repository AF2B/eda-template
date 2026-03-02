(ns core
  (:require [cheshire.core :as json]
            [ring.adapter.jetty :as jetty]
            [ring.util.response :as resp])
  (:import [org.apache.kafka.clients.producer KafkaProducer ProducerRecord]
           [java.util Properties UUID]))

(def topic "demo-topic")

(defn kafka-producer []
  (let [props (doto (Properties.)
                (.put "bootstrap.servers" "kafka:9092")
                (.put "key.serializer"
                      "org.apache.kafka.common.serialization.StringSerializer")
                (.put "value.serializer"
                      "org.apache.kafka.common.serialization.StringSerializer")
                (.put "acks" "all"))]
    (KafkaProducer. props)))

(def producer (delay (kafka-producer)))

(defn publish! [event]
  (let [payload (json/generate-string event)
        record  (ProducerRecord. topic payload)]
    (.send @producer record)))

(defn handler [_]
  (let [event {:event-id (str (UUID/randomUUID))
               :value    42
               :type     "demo-event"}]
    (publish! event)
    (resp/response "Event published")))

(defn -main []
  (jetty/run-jetty handler {:port 8080}))