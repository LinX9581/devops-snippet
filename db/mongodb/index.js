const { MongoClient } = require("mongodb");
const url = 'mongodb://localhost:27017';
const client = new MongoClient(url, { useNewUrlParser: true });

async function run() {
    try {
        await client.connect();
        const pizzaDocument = {
            name: "lin",
            shape: "round",
            toppings: ["San Marzano tomatoes", "mozzarella di bufala cheese"],
        };
        const database = client.db("GaData");
        const collection = database.collection("test");
        // await collection.insertOne(pizzaDocument);

        const result = await collection.findOne({ name: "lin" })
        console.log(result)
    } finally {
        await client.close();
    }
}
run().catch(console.dir);