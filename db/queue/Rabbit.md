RabbitMQ.

rabbitmq 跟 Kafka 的面向不同，rabbitmq 在意的是 message routing, Kafka 在意的是大量訊息的 scale 問題，所以 rabbitmq 提供了很多 filter 的方法message 去到不同的 queue 中去分發，Kafka 提供的是大量訊息時透過 partition 的機制去分流以及解決 ha 問題

SQS 在意的是無狀態擴充跟服務可用性，所以甚至沒有保證一個 message 只被處理一次，FIFO 則是有呼叫上限，如果你希望可以做到跟 Kafka 不同 group 不同 offset，可以用 SNS → 多個 SQS 然後在各自 comsum