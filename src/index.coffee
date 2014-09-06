express = require('express')
# fs = require('fs')
request = require('request')
# cheerio = require('cheerio')
lolapi = require './lolapi'
app     = express()




app.get('/scrape', (req, res)->
  lolapi.getSummnerIds()
)


app.get('/freeweek', (req, res)->
	lolapi.getFreeWeekChampions((data)->
		if data.error
			res.send data.error
		else
			res.send data.data
	)
)

app.get('/currentGameInfo', (req, res)->
	
	summnerUserName = req.query.sn 
	# res.send summnerUserName

	formData = "userName="+summnerUserName+"&force=true"
	options = 
		method: 'POST',
		uri: 'http://eune.op.gg/summoner/ajax/spectator/',
		# uri: 'http://posttestserver.com/post.php',
		body:formData,
		headers: 
			'Origin': 'http://eune.op.gg'
			'Referer': 'http://eune.op.gg/summoner/userName=' + summnerUserName
			'Host' : 'eune.op.gg'
			# 'X-Requested-With' : 'XMLHttpRequest'
			'Cookie': '_hist=DamKar%24Jaguar%20Rebirth%24wolfstrike%24Magiczna%20Malina%24bartole2%24Knifflor%24DuDu123%24SoVieTZarDaS%24eGoldenn'
			'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'
			# 'Connection': 'keep-alive'
			'Content-Length': formData.length
			'Cache-Control': 'no-cache'
			'Pragma': 'no-cache'
			'Accept': '*/*'
			'User-Agent':' Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
			# 'Accept-Encoding': 'gzip,deflate,sdch'
			'Accept-Language': 'he-IL,he;q=0.8,en-US;q=0.6,en;q=0.4'


	request(options,
		(error,response,body)->
			returnObject = 
				_error : error
				_response : response
				_body : body

			res.send body
	)
)
app.listen('5555')

console.log('Magic happens on port 5555')

exports = module.exports = app