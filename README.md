Snok
===========

###Snok is a super simple RSS sniffer that uses [Feedparser](https://github.com/danmactough/node-feedparser) to scan feeds for certain keywords and then... well, that's up to you.

Installation
------------

First you need to install [Node.js](https://nodejs.org/). After that, run the following command:

    npm install snok

Usage
-----
Just pass Snok the feeds, the triggers and a callback to handle the returned items. Example:

```javascript
const Snok = require('snok');

const feeds = [
	'https://news.ycombinator.com/rss'
]

const triggers = [
	'machine learning',
	'artificial intelligence',
	'automation',
	'AI && robotics' // Logical AND now supported
]

const notify = function (item) {
	console.log("Hey, there seems to be an interesting article out there!");
	console.log(item.link);
}

const secondsBetweenChecks = 60;

const snok = new Snok(feeds, triggers, notify);

setInterval(snok.sniff, secondsBetweenChecks * 1000);
snok.sniff();
```
    
License
-------

This little piece of software is licensed under the terms of the [ISC License](http://en.wikipedia.org/wiki/ISC_license).
