/*
 * Copyright (c) Microsoft. All rights reserved.
 * Licensed under the MIT license. See LICENSE file in the project root for full license information.
 */
package com.microsoft.azure.eventhubs.samples.testconsumereph.Models;

import lombok.Data;
import lombok.NonNull;

@Data
public class EventProcessorHostConfiguration {
    @NonNull
    private String consumerGroupName;

    @NonNull
    private String eventHubName;

    @NonNull
    private String storageConnectionString;

    @NonNull
    private String storageContainerName;

    @NonNull
    private String hostNamePrefix;

    @NonNull
    private String eventHubConnectionString;

    public EventProcessorHostConfiguration() {
    }
}
