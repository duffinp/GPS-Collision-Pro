const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const MongoClient = require('mongodb').MongoClient;
const destinationPoint = require('./toDest').destinationPoint;

const app = express();

app.use(cors());
//app.use(bodyParser.json());
//app.use(bodyParser.urlencoded({ extended: false }));

const mongoURL = process.env.MONGODB || 'mongodb://siteUser:pwd123@localhost:27017/boatDisaster';

var findDocuments = (db, cb) => {
	var collection = db.collection('map');
	collection.find().toArray((err, docs) => {
		if(err) throw err;
		cb(docs);
	})
}

var mClient;
MongoClient.connect(mongoURL).then(client => {
	mClient = client.db('boatDisaster');
	console.log('connected to db');
}).catch(err => {
	console.error(err);
	process.exit(-1);
	return;
});

function toRadians (angle) {
	return angle * (Math.PI / 180);
}

app.use("*", (req, res, next) => {
	console.log(req.url);
	next();
})

app.get("/api/v1/test", (req, res) => {

	const latitude = parseFloat(req.query.lat);
	const longitude = parseFloat(req.query.lng);
	
	const velocity = parseFloat(req.query.vel);
	const bearing = parseFloat(req.query.bearing);

	const c = [
		longitude,
		latitude
	]

	const m = destinationPoint(latitude, longitude, velocity, bearing);
	const p1 = destinationPoint(latitude, longitude, velocity, bearing - 45);
	const p2 = destinationPoint(latitude, longitude, velocity, bearing + 45);

	const coord = [ c, p2, m, p1, c ];
	const q = { $geometry: {type: "Polygon",coordinates: [ coord ] } }

	mClient.collection('map').find({
		"geometry": { $geoIntersects: q }
	}, (err, results) => {
		if(err) {
			return res.status(400);
		}
		results.toArray().then(arr => {
			let max = -100000000;
			let min =  100000000;
			for(let i of arr) {
				min = Math.min(i.properties.depthMin, min);
				max = Math.max(i.properties.depthMax, max);
			}
			return res.json({min: min, max: max, coord: coord });
		}).catch(err2 => {
			console.error(err2);
			return res.status(400);
		});
	});
});

app.use(function (err, req, res, next) {
    console.warn(`${err.name}: ${err.message}`);
    return res.status(400).send(`${err.name}: ${err.message}`);
});

app.listen(3000, () => {
	console.log("listening on port 3000");
});
