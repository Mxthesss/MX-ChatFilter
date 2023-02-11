Config = {}

function SendWebHook(MXLink, title, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] =  ""..message.."",
            ["footer"] ={
                ["text"] = "Made by Mxthess Development |"  ..timestamp.."  (Server Time).",
            },
        }
    }
    PerformHttpRequest(MXLink, function(err, text, headers)end, 'POST', json.encode({username = Config.MXName, avatar_url= Config.MXLogo ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end


AddEventHandler('MX_logs:sendWebhook', function(MXData)
    if MXData.link == nil then
        MXLink = Config.MXlink
    else
        MXLink = MXData.link
    end
    title = MXData.title
    color = MXData.color
    message = MXData.message
    SendWebHook(MXLink, title, color, message)
end)

-- what should happen when someone enteres a bad word
-- "delete": delete the message
-- "kick": kick the player and delete the message
local MXMode = "kick"

-- kick message (if 'mode' is set to 'kick')
local MXKickMessage = "[MX_ChatFilter] Swearing is not allowed."

-- blacklisted words (in lowercase)
local MXBlackList = {
	"negr",
	"Negr",
	"Nigga",
    "nigga",
    "Nigger",
    "Niggers",
    "nigger",
	"CK GANG",
	"ck gang",
	"CKGANG",
	"ckgang",
	"CK Mafie",
	"ck mafie",
	"CKMafie",
	"ckmafie",
	"za Německo",
	"Hitler",
	"hitler",
    "niggers"
}

-- END OF CONFIGURATION

AddEventHandler("chatMessage", function(source, author, message)
	if(IsPlayerAceAllowed(source, "chatfilter:bypass")) then else
		CancelEvent()
		local finalmessage = message:lower()
		finalmessage = finalmessage:gsub(" ", "")
		finalmessage = finalmessage:gsub("%-", "")
		finalmessage = finalmessage:gsub("%.", "")
		finalmessage = finalmessage:gsub("$", "s")
		finalmessage = finalmessage:gsub("€", "e")
		finalmessage = finalmessage:gsub(",", "")
		finalmessage = finalmessage:gsub(";", "")
		finalmessage = finalmessage:gsub(":", "")
		finalmessage = finalmessage:gsub("*", "")
		finalmessage = finalmessage:gsub("_", "")
		finalmessage = finalmessage:gsub("|", "")
		finalmessage = finalmessage:gsub("/", "")
		finalmessage = finalmessage:gsub("<", "")
		finalmessage = finalmessage:gsub(">", "")
		finalmessage = finalmessage:gsub("ß", "ss")
		finalmessage = finalmessage:gsub("&", "")
		finalmessage = finalmessage:gsub("+", "")
		finalmessage = finalmessage:gsub("¦", "")
		finalmessage = finalmessage:gsub("§", "s")
		finalmessage = finalmessage:gsub("°", "")
		finalmessage = finalmessage:gsub("#", "")
		finalmessage = finalmessage:gsub("@", "a")
		finalmessage = finalmessage:gsub("\"", "")
		finalmessage = finalmessage:gsub("%(", "")
		finalmessage = finalmessage:gsub("%)", "")
		finalmessage = finalmessage:gsub("=", "")
		finalmessage = finalmessage:gsub("?", "")
		finalmessage = finalmessage:gsub("!", "")
		finalmessage = finalmessage:gsub("´", "")
		finalmessage = finalmessage:gsub("`", "")
		finalmessage = finalmessage:gsub("'", "")
		finalmessage = finalmessage:gsub("%^", "")
		finalmessage = finalmessage:gsub("~", "")
		finalmessage = finalmessage:gsub("%[", "")
		finalmessage = finalmessage:gsub("]", "")
		finalmessage = finalmessage:gsub("{", "")
		finalmessage = finalmessage:gsub("}", "")
		finalmessage = finalmessage:gsub("£", "e")
		finalmessage = finalmessage:gsub("¨", "")
		finalmessage = finalmessage:gsub("ç", "c")
		finalmessage = finalmessage:gsub("¬", "")
		finalmessage = finalmessage:gsub("\\", "")
		finalmessage = finalmessage:gsub("1", "i")
		finalmessage = finalmessage:gsub("3", "e")
		finalmessage = finalmessage:gsub("4", "a")
		finalmessage = finalmessage:gsub("5", "s")
		finalmessage = finalmessage:gsub("0", "o")

		local lastchar = ""
		local output = ""
		for char in finalmessage:gmatch(".") do
			if(char ~= lastchar) then
				output = output .. char
			end
			lastchar = char
		end

		local send = true
		for i in pairs(MXBlackList) do
			if(output:find(MXBlackList[i])) then
				if(MXMode == "delete") then
					--message already deleted
				elseif(MXMode == "kick") then
					DropPlayer(source, MXKickMessage)
				end
				send = false
				break
			end
		end
		if(send) then
			TriggerClientEvent("chatMessage", -1, author, {255,255,255}, message)
		end
	end
end)



AddEventHandler('playerDropped', function(reason, name) 
    if Config.MXlink == '' then
		print('^7[^1INFO^7]: No default WebHook URL detected. Please configure the script correctly.')
	else 
		print('^7[^2INFO^7]: '..reason..' player say.')
		local MXData = {
			link = Config.MXlink,
			title = "PLAYER SAY",
			color = 4521728,
			message = ' **'..name..'** | has been kicked for: '..reason..'',
			footer
		}
		TriggerEvent('MX_logs:sendWebhook', MXData)
	end
end)



print('^5Made By Mxthess^7: ^1'..GetCurrentResourceName()..'^7 started ^2successfully^7...') 
