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