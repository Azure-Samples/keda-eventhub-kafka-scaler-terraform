/*
 * Copyright (c) Microsoft. All rights reserved.
 * Licensed under the MIT license. See LICENSE file in the project root for full license information.
 */
package com.microsoft.azure.eventhubs.samples.testconsumereph;

import com.microsoft.azure.eventhubs.samples.EventProcessorHostFactory;
import java.util.concurrent.ExecutionException;

public class TestConsumerEPH
{
    public static void main(String args[]) throws InterruptedException, ExecutionException
    {
		EventProcessorHostFactory eventProcessorHostFactory = new EventProcessorHostFactory();
        EventProcessorResult result = eventProcessorHostFactory.ProcessEvents();
        
        if (!result.isValid())
        {
            String message = String.format("%s: %s", result.getErrorMessage(), result.getExceptionMessage());
            System.out.println(message);
            return;
        }

        System.out.println("Events processing completed");
    }
}



