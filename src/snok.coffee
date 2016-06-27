request =       require 'request'
FeedParser =    require 'feedparser'

module.exports = class Snok

    MAX_SAVED_ITEMS: 1000

    constructor: (@feeds, @triggers, @callback, @log = false) ->
        @checkedItems = []

    sniff: () =>
        for feed in @feeds
            @_fetchAndParse(feed)

    _fetchAndParse: (feed) =>
        self = @

        feedParser = new FeedParser

        options =
            url: feed
            headers:
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
                'Accept': 'text/html,application/xhtml+xml'

        request
            .get options
            .on 'error', (error) ->
                console.error error if @log
            .on 'response', (response) ->
                unless response.statusCode is 200
                    console.error "Server responded with #{response.statusCode}..." if @log
            .pipe feedParser

        feedParser
            .on 'error', (error) ->
                console.error error if @log
            .on 'readable', () ->
                while item = @read()
                    self._examine item

    _examine: (item) =>
        item.guid = item.link if not item.guid
        return if item.guid in @checkedItems

        @checkedItems.shift() if @checkedItems.length > @MAX_SAVED_ITEMS
        @checkedItems.push item.guid

        containsTrigger = false
        text = item.title?.toLowerCase() or '' 
        text += item.description?.toLowerCase() or ''

        for trigger in @triggers
            if text.includes trigger
                containsTrigger = true
                break

        @callback item if containsTrigger