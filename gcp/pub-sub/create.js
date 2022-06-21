// Imports the Google Cloud client library
const { PubSub } = require('@google-cloud/pubsub');

async function createTopic(
  projectId = 'tactile-zephyr-336102', // Your Google Cloud Platform project ID
  topicName = 'my-topic1' // Name for the new topic to create
) {
  // Instantiates a client
  const pubsub = new PubSub({ projectId });

  // Creates the new topic
  const [topic] = await pubsub.createTopic(topicName);
  console.log(`Topic ${topic.name} created.`);
}
// createTopic();

async function createSubscription(topicName, subscriptionName) {
  // [START pubsub_create_pull_subscription]
  // Imports the Google Cloud client library
  const { PubSub } = require('@google-cloud/pubsub');

  // Creates a client
  const pubsub = new PubSub();

  /**
   * TODO(developer): Uncomment the following lines to run the sample.
   */
  // const topicName = 'my-topic';
  // const subscriptionName = 'my-sub';

  // Creates a new subscription
  await pubsub.topic(topicName).createSubscription(subscriptionName);
  console.log(`Subscription ${subscriptionName} created.`);

  // [END pubsub_create_pull_subscription]
}
// createSubscription('my-topic', 'my-topic-Subscription');

