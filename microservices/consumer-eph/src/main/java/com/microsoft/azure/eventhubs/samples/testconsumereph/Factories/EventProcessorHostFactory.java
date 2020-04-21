/*
 * Copyright (c) Microsoft. All rights reserved.
 * Licensed under the MIT license. See LICENSE file in the project root for full license information.
 */

package com.microsoft.azure.eventhubs.samples.testconsumereph.Factories;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

import com.microsoft.azure.eventhubs.samples.testconsumereph.Handlers.ErrorNotificationHandler;
import com.microsoft.azure.eventhubs.samples.testconsumereph.Models.EventProcessor;
import com.microsoft.azure.eventhubs.samples.testconsumereph.Models.EventProcessorHostConfiguration;
import com.microsoft.azure.eventhubs.samples.testconsumereph.Models.EventProcessorResult;
import com.microsoft.azure.eventprocessorhost.EventProcessorHost;
import com.microsoft.azure.eventprocessorhost.EventProcessorOptions;

public class EventProcessorHostFactory {
    private final EventProcessorHost host;

    public EventProcessorHostFactory(EventProcessorHostConfiguration config) {
        host = CreateEventProcessorHost(config);
    }

    public EventProcessorResult ProcessEvents() {
        EventProcessorOptions options = CreateEventProcessorOptions();
        CompletableFuture<Void> eventProcessorRegister = RegisterEventProcessor(options);

        return ExecuteEventProcessor(eventProcessorRegister);
    }

    private EventProcessorHost CreateEventProcessorHost(EventProcessorHostConfiguration config) {
        String hostName = EventProcessorHost.createHostName(config.getHostNamePrefix());

        return EventProcessorHost.EventProcessorHostBuilder
            .newBuilder(hostName, config.getConsumerGroupName())
            .useAzureStorageCheckpointLeaseManager(config.getStorageConnectionString(), config.getStorageContainerName(), null)
            .useEventHubConnectionString(config.getEventHubConnectionString(), config.getEventHubName())
            .build();
    }

    private EventProcessorOptions CreateEventProcessorOptions() {
        EventProcessorOptions options = new EventProcessorOptions();
        options.setExceptionNotification(new ErrorNotificationHandler());
        return options;
    }

    private CompletableFuture<Void> RegisterEventProcessor(EventProcessorOptions options) {
        System.out.println("Registering host named " + host.getHostName());

        return host
            .registerEventProcessor(EventProcessor.class, options)
            .whenComplete((unused, e) -> {
                // whenComplete passes the result of the previous stage through unchanged,
                // which makes it useful for logging a result without side effects.
                if (e != null) {
                    System.out.println("Failure while registering: " + e.toString());
                    if (e.getCause() != null) {
                        System.out.println("Inner exception: " + e.getCause().toString());
                    }
                }
            });
    }

    private EventProcessorResult ExecuteEventProcessor(CompletableFuture<Void> eventProcessorRegister) {
        EventProcessorResult result = new EventProcessorResult();

        try {
            eventProcessorRegister.thenAccept((unused) -> {
                // This stage will only execute if registerEventProcessor succeeded.
                // If it completed exceptionally, this stage will be skipped.
                System.out.println("Press enter to stop.");
                try {
                    while (true)
                        ;
                } catch (final Exception e) {
                    System.out.println("Keyboard read failed: " + e.toString());
                }
            }).thenCompose((unused) -> {
                // This stage will only execute if registerEventProcessor succeeded.
                //
                // Processing of events continues until unregisterEventProcessor is called.
                // Unregistering shuts down the
                // receivers on all currently owned leases, shuts down the instances of the
                // event processor class, and
                // releases the leases for other instances of EventProcessorHost to claim.
                return host.unregisterEventProcessor();
            }).exceptionally((e) -> {
                System.out.println("Failure while unregistering: " + e.toString());
                if (e.getCause() != null) {
                    System.out.println("Inner exception: " + e.getCause().toString());
                }
                return null;
            }).get(); // Wait for everything to finish
        } catch (InterruptedException | ExecutionException ex) {
            result.setErrorMessage("Error on processing events");
            result.setExceptionMessage(ex.getMessage());
        }

        return result;
    }
}
