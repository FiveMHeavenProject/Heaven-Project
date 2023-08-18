local svConfig = {}

-- Configuration
 svConfig.supportChecker = true -- Support Checker (If you use exports, it is recommended that you leave this on)
-- Antispam System (Beta)
local users = {}
function checkSpam(source, message)
    local BlockedStatus = false

    -- Checks if the user has sent a message before
    if users[source] == nil then
        users[source] = {time = os.time()}
        return false
    end

    -- Check if the message is a repeat of the last message
    if message == users[source].lastMessage then
        BlockedStatus = true
    end

    -- Check if the user has sent messages too quickly
    if os.time() - users[source].time < 5 then
        BlockedStatus = true
    end

    -- Update the user's information in the table
    users[source] = {lastMessage = message, time = os.time()}

    return BlockedStatus
end

exports('checkSpam', checkSpam)
