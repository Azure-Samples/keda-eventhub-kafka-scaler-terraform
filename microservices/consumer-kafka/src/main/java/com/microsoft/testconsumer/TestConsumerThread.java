//Copyright (c) Microsoft Corporation. All rights reserved.
//Licensed under the MIT License.
package com.microsoft.testconsumer;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.serialization.LongDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Collections;
import java.util.Properties;

public class TestConsumerThread implements Runnable {

    private final String TOPIC;
    
    //Each consumer needs a unique client ID per thread
    private static int id = 0;

    public TestConsumerThread(final String TOPIC){
        this.TOPIC = TOPIC;
    }

    public void run (){
        final Consumer<Long, String> consumer = createConsumer();
        System.out.println("Polling");

        try {
            while (true) {
                final ConsumerRecords<Long, String> consumerRecords = consumer.poll(1000);
                for(ConsumerRecord<Long, String> cr : consumerRecords) {
                    System.out.printf("Consumer Record:(%d, %s, %d, %d)\n", cr.key(), cr.value(), cr.partition(), cr.offset());
                }
                consumer.commitAsync();
            }
        } catch (CommitFailedException e) {
            System.out.println("CommitFailedException: " + e);
        } finally {
            consumer.close();
        }
    }

    private Consumer<Long, String> createConsumer() {
        try {
            final Properties properties = new Properties();
            synchronized (TestConsumerThread.class) {
                properties.put(ConsumerConfig.CLIENT_ID_CONFIG, "KafkaExampleConsumer#" + id);
                id++;
            }
            String bootstrapServers = System.getenv("EVENTHUB_NAMESPACE") + ".servicebus.windows.net:9093";
            String saslJaasConfig = "org.apache.kafka.common.security.plain.PlainLoginModule required username='$ConnectionString' password='"+ System.getenv("EVENTHUB_CONNECTIONSTRING") +"';";

            properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class.getName());
            properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

            properties.put("bootstrap.servers"  , bootstrapServers);
            properties.put("group.id"           , System.getenv("CONSUMER_GROUP"));
            properties.put("request.timeout.ms" , "60000");
            properties.put("security.protocol"  , "SASL_SSL");
            properties.put("sasl.mechanism"     , "PLAIN");
            properties.put("sasl.jaas.config"   , saslJaasConfig);

            // Create the consumer using properties.
            final Consumer<Long, String> consumer = new KafkaConsumer<>(properties);

            // Subscribe to the topic.
            consumer.subscribe(Collections.singletonList(TOPIC));
            return consumer;
            
        } catch (Exception e){
            System.out.println("Exception: " + e);
            System.exit(1);
            return null;        //unreachable
        }
    }
}
