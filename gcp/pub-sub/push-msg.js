const { PubSub } = require('@google-cloud/pubsub');
async function publishMessage(topicName, data) {
    // [START pubsub_publish]
    // [START pubsub_quickstart_publisher]
    // Imports the Google Cloud client library
    const { PubSub } = require('@google-cloud/pubsub');
  
    // Creates a client
    const pubsub = new PubSub();
  
    /**
     * TODO(developer): Uncomment the following lines to run the sample.
     */
    // const topicName = 'my-topic';
    // const data = JSON.stringify({ foo: 'bar' });
  
    // Publishes the message as a string, e.g. "Hello, world!" or JSON.stringify(someObject)
    const dataBuffer = Buffer.from(data);
  
    const messageId = await pubsub.topic(topicName).publish(dataBuffer);
    console.log(`Message ${messageId} published.`);
  
    // [END pubsub_publish]
    // [END pubsub_quickstart_publisher]
  }
  // publishMessage('my-topic', 'TestadasdData');
