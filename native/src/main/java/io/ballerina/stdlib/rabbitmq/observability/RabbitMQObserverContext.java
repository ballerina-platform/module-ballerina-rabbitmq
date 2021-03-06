/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.rabbitmq.observability;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import io.ballerina.runtime.observability.ObserverContext;

/**
 * Extension of ObserverContext for RabbitMQ.
 *
 * @since 1.2.0
 */
public class RabbitMQObserverContext extends ObserverContext {

    RabbitMQObserverContext() {
        setObjectName(RabbitMQObservabilityConstants.CONNECTOR_NAME);
    }

    RabbitMQObserverContext(Connection connection) {
        this();
        addTag(RabbitMQObservabilityConstants.TAG_URL, RabbitMQObservabilityUtil.getServerUrl(connection));
    }

    public RabbitMQObserverContext(Channel channel) {
        this(channel.getConnection());
        addTag(RabbitMQObservabilityConstants.TAG_CHANNEL, channel.toString());
    }

}
