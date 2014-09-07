request = require('request')

apiKey = "495d1248-253b-4f9b-b576-89cf95263f6e"

module.exports.getLeagueInfo = (callback,summnerNames,region)->
	summnerNames = JSON.parse summnerNames
	correctSyntaxNames= summnerNames[0]
	if summnerNames.length > 1
		for i in [1...summnerNames.length] by 1
			correctSyntaxNames += "," + summnerNames[i]

	apiUrl = "https://eune.api.pvp.net/api/lol/eune/v1.4/summoner/by-name/"+summnerNames+"?api_key=" + apiKey
	request({method:'GET',uri:apiUrl,headers:{'Accept-Language': 'en-US','Accept-Charset': 'ISO-8859-1,utf-8'}},(error,response,body)->
		returnObject = 
			error : error
			data : body
		if error 
			callback(returnObject)


		apiUrl_summnerLeagues = "https://eune.api.pvp.net/api/lol/eune/v2.5/league/by-summoner/" #+"/entry?api_key="+apiKey
		summnerIds = JSON.parse body
		correctSyntaxIds = ""
		correctSyntaxIds += summnerIds[(unescape(summnerNames[0])).replace(/\s/g, '')].id

		if summnerNames.length > 1
			for i in [1...summnerNames.length] by 1
				correctSyntaxIds += "," + summnerIds[(unescape(summnerNames[i])).replace(/\s/g, '')].id

		apiUrl_summnerLeagues += correctSyntaxIds+"/entry?api_key="+apiKey
		request({method:'GET',uri:apiUrl_summnerLeagues,headers:{'Accept-Language': 'en-US','Accept-Charset': 'ISO-8859-1,utf-8'}},(error,response,body)->
			returnObject = 
				error : error
				data : body
			if error 
				callback(returnObject)
			summnerLeages = JSON.parse body

			returnData = {}
			# console.log summnerIds
			for i in [0...summnerNames.length] by 1
				returnData[summnerNames[i]] = summnerLeages[summnerIds[(unescape(summnerNames[i])).replace(/\s/g, '')].id]
			
			returnObject.data = returnData
			callback(returnObject)
		)
	)

module.exports.getFreeWeekChampions = (callback,region)->
	championsSpriteUrl = "https://ddragon.leagueoflegends.com/cdn/4.15.1/img/sprite/"
	championsSplashScreenUrl = "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/" #+name+'_0'.jpg
	championsBigSingleSpriteUrl = "http://ddragon.leagueoflegends.com/cdn/4.14.2/img/champion/"
	championsloadingScreenUrl = "http://ddragon.leagueoflegends.com/cdn/img/champion/loading/"
	apiUrl = "https://eune.api.pvp.net/api/lol/eune/v1.2/champion?freeToPlay=true&api_key=" + apiKey
	championsDataUrl = "https://eune.api.pvp.net/api/lol/static-data/eune/v1.2/champion?champData=image&api_key="+apiKey


	request({method:'GET',uri:apiUrl,headers:{'Accept-Language': 'en-US','Accept-Charset': 'ISO-8859-1,utf-8'}},(error,response,body)->
		returnObject = 
			error : error
			data : body
		if error 
			callback(returnObject)

		freeweekChampIds = JSON.parse body

		request({method:'GET',uri:championsDataUrl,headers:{'Accept-Language': 'en-US','Accept-Charset': 'ISO-8859-1,utf-8'}},(error,response,body)->
			returnObject = 
				error : error
				data : body
			if error
				callback(returnObject)

			returnObject.data = []
			championsByIds = {}
			championsListRecived = (JSON.parse(body)).data

			for champion in Object.keys(championsListRecived)
				championsByIds[championsListRecived[champion].id] = championsListRecived[champion]

			for championId in freeweekChampIds.champions
				championData = championsByIds[championId.id]
				championData.image.splashUrl = championsSplashScreenUrl+championData.key+'_0.jpg'
				championData.image.loadingUrl = championsloadingScreenUrl+championData.key+'_0.jpg'
				championData.image.spriteUrl = championsSpriteUrl+championData.image.sprite
				championData.image.bigSprite = championsBigSingleSpriteUrl+championData.image.full

				returnObject.data.push championData
			
			callback(returnObject)
		)
	)