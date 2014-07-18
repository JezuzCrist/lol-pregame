express = require('express')
fs = require('fs')
request = require('request')
cheerio = require('cheerio')
app     = express()

app.get('/scrape', (req, res)->

  console.log "mekmek"

)
app.get('/', (req, res)->

)
app.listen('5555')

console.log('Magic happens on port 5555')

exports = module.exports = app