/*
 * Copyright (c) Microsoft. All rights reserved.
 * Licensed under the MIT license. See LICENSE file in the project root for full license information.
 */
package com.microsoft.azure.eventhubs.samples.testconsumereph.Models;

import lombok.Data;
import lombok.NonNull;

@Data
public class EventProcessorResult {
    private boolean Valid = true;

    @NonNull
    private String ErrorMessage = "";

    @NonNull
    private String ExceptionMessage = "";
}
