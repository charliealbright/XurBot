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

	#	Quotes for when Xur gets tagged in chat but has not "arrived" in destiny yet.
	XurAwayQuotes = [
		"I am not present, Guardian...",
		"The Nine require me elsewhere.",
		"I have no wares for you, Guardian....yet.",
		"Soon, Guardian.",
		"The time is not right...you will know when I arrive.",
		"Patience. The time will come.",
		"I am held up by other matters.",
	]
	guardianClasses = 
		0: "Titan"
		1: "Hunter"
		2: "Warlock"
		3: ""

	robot.respond /.*(items|inventory|sale|goods).*/i, (msg) ->
		responseString = "My wares, Guardian...\n"
		msg.http('https://www.bungie.net/platform/destiny/advisors/xur/?definitions=true').get() (error, response, body) ->
			data = JSON.parse(body)
			if !(data.Response.data?)
				msg.send msg.random XurAwayQuotes
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
	
	robot.hear /(^|\s)xur/i, (msg) ->
		msg.send msg.random XurQuotes
						
  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
