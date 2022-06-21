const { PubSub } = require('@google-cloud/pubsub');

// listenForMessages('SOC', 5);

function listenForMessages(subscriptionName, timeout) {
  // [START pubsub_subscriber_async_pull]
  // [START pubsub_quickstart_subscriber]
  // Imports the Google Cloud client library
  const { PubSub } = require('@google-cloud/pubsub');

  // Creates a client
  const pubsub = new PubSub();

  /**
   * TODO(developer): Uncomment the following lines to run the sample.
   */
  // const subscriptionName = 'my-sub';
  // const timeout = 60;

  // References an existing subscription
  const subscription = pubsub.subscription(subscriptionName);

  // Create an event handler to handle messages
  let messageCount = 0;
  const messageHandler = message => {
    // console.log(`Received message ${message.id}:`);
    // console.log(`\tData: ${message.data}`);
    console.log(message.data);
    // console.log(`\tAttributes: ${message.attributes}`);
    messageCount += 1;

    // "Ack" (acknowledge receipt of) the message
    message.ack();
  };

  // Listen for new messages until timeout is hit
  subscription.on(`message`, messageHandler);

  setTimeout(() => {
    subscription.removeListener('message', messageHandler);
    console.log(`${messageCount} message(s) received.`);
  }, timeout * 1000);
  // [END pubsub_subscriber_async_pull]
  // [END pubsub_quickstart_subscriber]
}
