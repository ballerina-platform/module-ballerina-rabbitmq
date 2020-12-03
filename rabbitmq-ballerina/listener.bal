// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/java;
import ballerina/system;

# Ballerina RabbitMQ Message Listener.
# Provides a listener to consume messages from the RabbitMQ server.
public class Listener {

    string connectorId = system:uuid();

    # Initializes a Listener object with the given `rabbitmq:Connection` object or connection configurations.
    # Creates a `rabbitmq:Connection` object if only the connection configuration is given. Sets the global QoS settings,
    # which will be applied to the entire `rabbitmq:Channel`.
    #
    # + connectionData - A connection configuration or the connection uri
    # + qosSettings - Consumer prefetch settings
    public isolated function init(ConnectionConfig connectionData = {},
                                     QosSettings? qosSettings = ()) {
        externInit(self, connectionData);
        if (qosSettings is QosSettings) {
            checkpanic nativeSetQosSettings(qosSettings.prefetchCount, qosSettings?.prefetchSize,
                qosSettings.global, self);
        }
    }

    # Attaches the service to the `rabbitmq:Listener` endpoint.
    #
    # + s - Type descriptor of the service
    # + name - Name of the service
    # + return - `()` or else a `rabbitmq:Error` upon failure to register the service
    public isolated function attach(RabbitmqService s, string[]|string? name = ()) returns error? {
        return registerListener(self, s);
    }

    # Starts consuming the messages on all the attached services.
    #
    # + return - `()` or else a `rabbitmq:Error` upon failure to start
    public isolated function 'start() returns error? {
        return 'start(self);
    }

    # Stops consuming messages and detaches the service from the `rabbitmq:Listener` endpoint.
    #
    # + s - Type descriptor of the service
    # + return - `()` or else  a `rabbitmq:Error` upon failure to detach the service
    public isolated function detach(RabbitmqService s) returns error? {
        return detach(self, s);
    }

    # Stops consuming messages through all consumer services by terminating the connection and all its channels.
    #
    # + return - `()` or else  a `rabbitmq:Error` upon failure to close the `ChannelListener`
    public isolated function gracefulStop() returns error? {
        return stop(self);
    }

    # Stops consuming messages through all the consumer services and terminates the connection
    # with the server.
    #
    # + return - `()` or else  a `rabbitmq:Error` upon failure to close ChannelListener.
    public isolated function immediateStop() returns error? {
        return abortConnection(self);
    }
}

# Configurations required to create a subscription.
#
# + queueName - Name of the queue to be subscribed
# + autoAck - If false, should manually acknowledge
public type RabbitMQServiceConfig record {|
    string queueName;
    boolean autoAck = true;
|};

# The annotation, which is used to configure the subscription.
public annotation RabbitMQServiceConfig ServiceConfig on service, class;

isolated function externInit(Listener lis, ConnectionConfig connectionData) =
@java:Method {
    name: "init",
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function registerListener(Listener lis, RabbitmqService serviceType) returns Error? =
@java:Method {
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function 'start(Listener lis) returns Error? =
@java:Method {
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function detach(Listener lis, RabbitmqService serviceType) returns Error? =
@java:Method {
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function stop(Listener lis) returns Error? =
@java:Method {
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function abortConnection(Listener lis) returns Error? =
@java:Method {
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;

isolated function nativeSetQosSettings(int count, int? size, boolean global, Listener lis) returns Error? =
@java:Method {
    name: "setQosSettings",
    'class: "org.ballerinalang.messaging.rabbitmq.util.ListenerUtils"
} external;