request = require('request')

apiKey = "495d1248-253b-4f9b-b576-89cf95263f6e"

module.exports.getSummnerIds = (region,summnerNames)->
	correctSyntaxNames= summnerNames[0]
	if summnerNames.length > 1
		for summnerName in summnerNames
			summnerNames += "," + summnerName
	
	apiUrl = "https://eune.api.pvp.net/api/lol/eune/v1.4/summoner/by-name/"+summnerNames+"?api_key=" + apiKey

module.exports.getFreeWeekChampions = (callback,region)->
	champSprite = "https://ddragon.leagueoflegends.com/cdn/4.15.1/img/sprite"
	championsSplashScreenUrl = "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/" #+name+'_0'.jpg
	
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
				# console.log champion
				championsByIds[championsListRecived[champion].id] = championsListRecived[champion]
			# console.log championsByIds
			# lo
			# console.log freeweekChampIds
			for championId in freeweekChampIds.champions
				championData = championsByIds[championId.id]
				championData.image.splash = championsSplashScreenUrl+championData.key+'_0.jpg'
				returnObject.data.push championData
			
			callback(returnObject)
		)
	)