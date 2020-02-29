//Copyright (c) Microsoft Corporation. All rights reserved.
//Licensed under the MIT License.
package com.microsoft.testconsumer;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
//import com.microsoft.testconsumer.*;

public class TestConsumer {
    //Change constant to send messages to the desired topic
    private final static String TOPIC = System.getenv("EVENTHUB_NAME");
    
    private final static int NUM_THREADS = 1;

    public static void main(String... args) throws Exception {

        final ExecutorService executorService = Executors.newFixedThreadPool(NUM_THREADS);

        for (int i = 0; i < NUM_THREADS; i++){
            executorService.execute(new TestConsumerThread(TOPIC));
        }
    }
}
