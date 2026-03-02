(ns core
  (:require [cheshire.core :as json])
  (:import [org.apache.kafka.clients.consumer KafkaConsumer]
           [java.util Properties Collections]))

(def topic "demo-topic")

(defn consumer []
  (let [props (doto (Properties.)
                (.put "bootstrap.servers" "kafka:9092")
                (.put "group.id" "demo-group")
                (.put "key.deserializer"
                      "org.apache.kafka.common.serialization.StringDeserializer")
                (.put "value.deserializer"
                      "org.apache.kafka.common.serialization.StringDeserializer")
                (.put "auto.offset.reset" "earliest"))
        c (KafkaConsumer. props)]
    (.subscribe c (Collections/singletonList topic))
    c))

(defn consume-loop [c]
  (while true
    (doseq [record (.poll c (java.time.Duration/ofMillis 1000))]
      (println "Received:"
               (json/parse-string (.value record) true)))))

(defn -main []
  (let [c (consumer)]
    (consume-loop c)))