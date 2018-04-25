const express = require('express');
const fs = require('fs');
const readline = require('readline');

var rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout,
	terminal: false
});

const MongoClient = require('mongodb').MongoClient;

const mongoURL = process.env.MONGODB || 'mongodb://siteUser:pwd123@localhost:27017/boatDisaster';

var mClient;
MongoClient.connect(mongoURL).then(client => {
	mClient = client;
	console.log('connected to db');
}).catch(err => {
	console.error(err);
	process.exit(-1);
	return;
});

rl.on('line', function(path){
	console.log('reading' + path);
	fs.readFile(path, (err, data) => {
		if (err) throw err;
		var items = JSON.parse(data);
		items = items.features;
		items = items.map(i => {
			let n = {
				type: i.type,
				properties: {
					depthMin: i.properties.DYBDE_MIN,
					depthMax: i.properties.DYBDE_MAX
				},
				geometry: i.geometry
			}
			return n;
		});
		mClient.db('boatDisaster').collection('map').insert(items).then(res => {
			console.log(res);
		}).catch(err => {
			console.error(err);
		});
	});
})