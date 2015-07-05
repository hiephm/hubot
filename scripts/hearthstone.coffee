# Description:
#   Script for searching Hearthstone cards
#
# Notes:
#

module.exports = (robot) ->
  robot.respond /hs (.*)/i, (msg) ->
    cardToSearch = encodeURIComponent(msg.match[1])
    robot.http("https://omgvamp-hearthstone-v1.p.mashape.com/cards/search/#{cardToSearch}")
    .header('Accept', 'application/json')
    .header('X-Mashape-Key', 'HQXHC6BUgLmshDjgCoQPImTLxNlEp1j28WrjsnTZPZFbBkiPpp')
    .get() (err, res, body) ->
      # err & response status checking code here
      if err
        msg.send "Encountered an error :( #{err}"
        return
      if res.statusCode isnt 200
        msg.send "Card not found. Try to correct your keywords."
        return

      data = JSON.parse(body)

      count = 0
      if data.length > 0
        for card in data
          count += showHSCard card, msg
          if count is 3
            break
      else
        msg.send "Card not found. Try to correct your keywords."
        return

showHSCard = (card, msg) ->
  if not card.collectible or not card.img?
    return 0

  cardClass = card.playerClass ? 'Neutral'
  msg.send "Found hearthstone card *#{card.name}* _(#{cardClass})_ #{card.img}"
  return 1
