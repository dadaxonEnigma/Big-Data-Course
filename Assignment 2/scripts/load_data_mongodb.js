const fs = require("fs");
const csv = require("csv-parser");
const path = require("path");
const { MongoClient, ObjectId } = require("mongodb");

const MONGO_URI = "mongodb://localhost:27018";
const DB_NAME = "Ecommerce";
const client = new MongoClient(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });

const CSV_FILES = {
    "campaigns": "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/cleaned_campaigns.csv",
    "events": "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/cleaned_events.csv",
    "messages": "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/cleaned_messages.csv",
    "friends": "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/cleaned_friends.csv",
    "client_first_purchase_date": "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/cleaned_client_first_purchase_date.csv"
};

const BATCH_SIZE = 10000;

async function loadCSVToMongoDB(db, collection, csvFile) {
    let batch = [];
    let insertedCount = 0, duplicateCount = 0;
    console.log(`🔄 Uploading CSV: ${csvFile}`);
    
    return new Promise((resolve, reject) => {
        fs.createReadStream(csvFile)
            .pipe(csv())
            .on("data", (row) => {
                try {
                    row._id = row._id ? new ObjectId(row._id) : new ObjectId();
                } catch (e) {
                    row._id = new ObjectId();
                }

                batch.push({ insertOne: { document: row } });

                if (batch.length >= BATCH_SIZE) {
                    processBatch(db, collection, batch)
                        .then(({ inserted, duplicates }) => {
                            insertedCount += inserted;
                            duplicateCount += duplicates;
                        })
                        .catch(console.error);
                    batch = [];
                }
            })
            .on("end", async () => {
                if (batch.length > 0) {
                    const { inserted, duplicates } = await processBatch(db, collection, batch);
                    insertedCount += inserted;
                    duplicateCount += duplicates;
                }
                console.log(`✅ ${collection}: Inserted ${insertedCount}, duplicates: ${duplicateCount}`);
                resolve();
            })
            .on("error", (err) => {
                console.error(`❌ Error CSV (${collection}):`, err);
                reject(err);
            });
    });
}

async function processBatch(db, collection, batch) {
    try {
        const result = await db.collection(collection).bulkWrite(batch, { ordered: false });
        return { inserted: result.insertedCount, duplicates: 0 };
    } catch (err) {
        if (err.code === 11000) {
            console.log(`🔴 Duplicates when pasted into ${collection}: ${err.writeErrors?.length || 0}`);
            return { inserted: 0, duplicates: err.writeErrors?.length || 0 };
        } else {
            console.error(`❌ Insertion error in ${collection}:`, err);
            return { inserted: 0, duplicates: 0 };
        }
    }
}

async function main() {
    try {
        await client.connect();
        const db = client.db(DB_NAME);

        // Deleting the database and recreating it
        await db.dropDatabase();
        console.log(`💾 База данных ${DB_NAME} пересоздана`);

        // Creating collections
        for (let collection in CSV_FILES) {
            await db.createCollection(collection);
            console.log(`📂 Collection ${collection} created`);
        }

        const collections = await db.listCollections().toArray();
        console.log("📁 Collections in the database:", collections.map(c => c.name));

        await Promise.all(
            Object.entries(CSV_FILES).map(([collection, csvFile]) => {
                return loadCSVToMongoDB(db, collection, csvFile);
            })
        );

        console.log("🎉 All data has been uploaded!");
    } catch (err) {
        console.error("❌ Error:", err);
    } finally {
        await client.close();
    }
}

main();
