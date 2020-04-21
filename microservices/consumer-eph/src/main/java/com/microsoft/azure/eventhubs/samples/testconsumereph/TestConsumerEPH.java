/*
 * Copyright (c) Microsoft. All rights reserved.
 * Licensed under the MIT license. See LICENSE file in the project root for full license information.
 */
package com.microsoft.azure.eventhubs.samples.testconsumereph;

import com.microsoft.azure.eventhubs.samples.EventProcessorHostFactory;
import java.util.concurrent.ExecutionException;

public class TestConsumerEPH
{
    // private static final String consumerGroupName = System.getenv("CONSUMER_GROUP");
    // private static final String eventHubName = System.getenv("EVENTHUB_NAME");
    // private static final String storageConnectionString = System.getenv("STORAGE_CONNECTIONSTRING");
    // private static final String storageContainerName = System.getenv("BLOB_CONTAINER");
    // private static final String hostNamePrefix = "eph";
    // private static final String eventHubConnectionString = System.getenv("EVENTHUB_CONNECTIONSTRING");
    public static void main(String args[]) throws InterruptedException, ExecutionException
    {
        EventProcessorHostConfiguration config = CreateEventProcessorHostConfiguration();
		EventProcessorHostFactory ephFactory = new EventProcessorHostFactory(config);
        EventProcessorResult result = ephFactory.ProcessEvents();
        
        if (!result.isValid())
        {
            String message = String.format("%s: %s", result.getErrorMessage(), result.getExceptionMessage());
            System.out.println(message);
            return;
        }

        System.out.println("Events processing completed");
    }

    private static EventProcessorHostConfiguration CreateEventProcessorHostConfiguration() {
        EventProcessorHostConfiguration config = new EventProcessorHostConfiguration();

        config.setConsumerGroupName(System.getenv("CONSUMER_GROUP"));
        config.setEventHubName(System.getenv("EVENTHUB_NAME"));
        config.setStorageConnectionString(System.getenv("STORAGE_CONNECTIONSTRING"));
        config.setStorageContainerName(System.getenv("BLOB_CONTAINER"));
        config.setHostNamePrefix("eph");
        config.setEventHubConnectionString(System.getenv("EVENTHUB_CONNECTIONSTRING"));

        return config;
    }
}

