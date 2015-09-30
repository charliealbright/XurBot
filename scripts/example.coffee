# Description:
#   XurBot is a Hubot-variant written for Slack. When tagged in a chat, 
#	XurBot will respond with either a random quote when he is "gone" from Destiny, or a list of his items for sale.
#
# Notes:
#   URLS:
#		- REAL: https://www.bungie.net/platform/destiny/advisors/xur/?definitions=true
#		- OTHER: https://lyle.smu.edu/~calbright/xurbot/exampleData.json
#			- For testing when Xur is gone and the real endpoint has no data
#	

module.exports = (robot) ->
	
	#	Developer Key for making requests through Bungie's API
	BUNGIE_API_KEY = "276eb0f983144621a969cf7c07ea61c7"
	
	#	Random quotes for when Xur gets mentioned in chat
	XurQuotes = [
		"I am only an Agent. The Nine rule beyond the Jovians.",
		"I cannot explain what the Nine are. They are... very large. I cannot explain. The fault is mine, not yours.",
		"I think it is very possible that I am here to help you.",
		"Each mote of dust tells a story of ancient Earth.",
		"I think the cells of this body are dying...",
		"I do not entirely control my movements.",
		"Some of the cells in this body began on this world, how strange to return.",
		"There are no birds where I came from. The things that fly... are like shadows.",
		"I understood my mission when the Nine put it in me, but now I cannot articulate it.",
		"This is but one end.",
		"These inner worlds are very strange.",
		"My movements are to a significant degree dependent on planetary alignments.",
		"I feel a great many consciousnesses impinging on mine, and all of them so small and lonely.",
		"Bodies come and go but the cells remember. And if they forget, the Nine remember it for us.",
		"My function here is to trade, I know this.",
		"I have told you what I can.",
		"If I am here, it is The Nine who sent me.",
		"I may be here.",
		"May we speak?",
		"So much Light here, I suppose I feel pain.",
		"Please.",
		"Beyond even the outer worlds, the true deep begins.",
		"My movements are not predictable, even to me!",
		"We saw the colony fail, not knowing what we saw.",
		"My will is not my own.",
		"I am an Agent of the Nine.",
		"I hope to be here again.",
		"It is very possible that the Nine intend to help humanity.",
		"It is my will to speak to you.",
		"An end will come. We will be there.",
		"The Awoken did not have a choice. We did.",
		"This is the Nine.",
		"Speak with me.",
		"I may be here when you return.",
		"I do not know what the Nine want with you.",
		"There is something inside me that wishes to connect.",
		"The Nine show you these.",
		"An end will come. We will be here.",
		"For organic life to exist it requires constant adaptation.",
		"Guardian!",
		"The Nine wish to speak to you.",
		"Do not be alarmed, I have no reason to cause you harm.",
		"But it was the Nine who gave us purpose, and it was the Nine who keep us whole.",
		"We came up from the dust, and burrowed into flesh for warmth, and became... something new.",
		"I have information. I do not know yet if it's you it is for.",
		"The pull of the outer worlds is so faint here. The sun is so heavy.",
		"Your Traveler has a dark mirror.",
		"You are the one I was sent to find!",
		"When my mission here is done, the Nine will send for me.",
		"I came for the Light, perhaps. To understand the Light.",
		"My movements are not fully under my own control..is it different for you?",
		"What sort of thing are you?"
	]

	guardianClasses = 
		0: "Titan"
		1: "Hunter"
		2: "Warlock"
		3: ""

	robot.respond /.*(items|inventory|sale|goods).*/i, (msg) ->
		responseString = ""
		msg.http('https://www.bungie.net/platform/destiny/advisors/xur/?definitions=true')
		.headers('X-API-Key': BUNGIE_API_KEY).get() (error, response, body) ->
			data = JSON.parse(body)
			if !(data.Response.data?)
				msg.send "_Xur has not yet arrived..._"
			else
				itemCategories = data.Response.data.saleItemCategories
				for category in itemCategories
					responseString += "\n*" + category.categoryTitle + ":*\n"
					itemList = category.saleItems
					for item in itemList
						hash = item.item.itemHash
						count = item.item.stackSize
						currencyHash = item.costs[0].itemHash
						currency = data.Response.definitions.items[currencyHash]
						currencyName = currency.itemName
						currencyCost = item.costs[0].value
						itemData = data.Response.definitions.items[hash]
						responseString += "> *" + itemData.itemName + "*" + " _" + guardianClasses[itemData.classType] + " " + itemData.itemTypeName + "_ " +
							(if count > 1 then "(" + count + ")" else "") + " - " + currencyCost + " " + currencyName + (if currencyCost > 1 then "s" else "") +
							"\n"
				msg.send responseString
		
	robot.respond /.*(where|location).*/i, (msg) ->
		regex = /\/assets\/findxur\/.*\.png/i
		msg.http('http://www.destinylfg.com/findxur/').get() (error, response, body) ->
			match = body.match regex
			msg.send "http://www.destinylfg.com" + match[0]
			
	robot.respond /.*/i, (msg) ->
		msg.send msg.random XurQuotes
