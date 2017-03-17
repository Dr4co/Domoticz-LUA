--
-- Domoticz passes information to scripts through a number of global tables
--
-- otherdevices, otherdevices_lastupdate and otherdevices_svalues are arrays for all devices: 
--   otherdevices['yourotherdevicename'] = "On"
--   otherdevices_lastupdate['yourotherdevicename'] = "2015-12-27 14:26:40"
--   otherdevices_svalues['yourotherthermometer'] = string of svalues
--
-- uservariables and uservariables_lastupdate are arrays for all user variables: 
--   uservariables['yourvariablename'] = 'Test Value'
--   uservariables_lastupdate['yourvariablename'] = '2015-12-27 11:19:22'
--
-- other useful details are contained in the timeofday table
--   timeofday['Nighttime'] = true or false
--   timeofday['SunriseInMinutes'] = number
--   timeofday['Daytime'] = true or false
--   timeofday['SunsetInMinutes'] = number
--   globalvariables['Security'] = 'Disarmed', 'Armed Home' or 'Armed Away'
--
-- To see examples of commands see: http://www.domoticz.com/wiki/LUA_commands#General
-- To get a list of available values see: http://www.domoticz.com/wiki/LUA_commands#Function_to_dump_all_variables_supplied_to_the_script
--
-- Based on your logic, fill the commandArray with device commands. Device name is case sensitive. 
--
commandArray = {}

if (devicechanged ~= nil) then
    -- Debug purposes
    -- print(devicechanged['Dummy Selector Switch']) 
    currentTimeString = os.date("%Y-%m-%d %H:%M:%S") 

    if (devicechanged['Utomhus Switch'] ~= nil) then
        -- DEBUG
        -- print("devicechanged['Utomhus Switch']: " .. devicechanged['Utomhus Switch'])

-- 2017-01-17 20:43:07.817 User: Admin initiated a switch command (34/Utomhus Switch/Off)
-- 2017-01-17 20:43:07.817 OpenZWave: Domoticz has send a Switch command! NodeID: 5 (0x05)
-- 2017-01-17 20:43:07.848 LUA: devicechanged['Utomhus Switch']: Off
-- 2017-01-17 20:43:07.848 EventSystem: Script event triggered: UtomhusSwitchNotification
-- 2017-01-17 20:43:07.817 (Z-Stick) Light/Switch (Utomhus Switch)
-- 2017-01-17 20:43:09.363 Notification sent (http) => Success
-- 2017-01-17 20:43:15.035 User: Admin initiated a switch command (34/Utomhus Switch/On)
-- 2017-01-17 20:43:15.035 OpenZWave: Domoticz has send a Switch command! NodeID: 5 (0x05)
-- 2017-01-17 20:43:15.067 LUA: devicechanged['Utomhus Switch']: On
-- 2017-01-17 20:43:15.067 EventSystem: Script event triggered: UtomhusSwitchNotification
-- 2017-01-17 20:43:15.035 (Z-Stick) Light/Switch (Utomhus Switch)
-- 2017-01-17 20:43:15.692 (Fjärris) Temp + Humidity (Krypgrund 2)
-- 2017-01-17 20:43:16.567 Notification sent (http) => Success
-- 2017-01-17 20:43:19.817 (Fjärris) Temp + Humidity (Krypgrund 1)

        -- Syntax: The total command is:
        --- commandArray['SendNotification']='subject#body#extraData#priority#sound'
        commandArray['SendNotification']='Utomhus#Utomhus Swich ' .. devicechanged['Utomhus Switch'] .. ' ' .. currentTimeString ..'!##0'
    end
    
    if (devicechanged['Ytterdörr'] ~= nil) then
        if (devicechanged['Ytterdörr'] == 'On') then
            commandArray['SendNotification']='Dörr#Ytterdörren Öppen ' .. currentTimeString ..'!##0'    
        else
            commandArray['SendNotification']='Dörr#Ytterdörren Stängs ' .. currentTimeString ..'!##0'    
        end
    end

    if (devicechanged['Altandörr'] ~= nil) then
        if (devicechanged['Altandörr'] == 'On') then
            commandArray['SendNotification']='Dörr#Altandörr Öppen ' .. currentTimeString ..'!##0'    
        else
            commandArray['SendNotification']='Dörr#Altandörr Stängs ' .. currentTimeString ..'!##0'    
        end
    end

    --- DEBUG
    --- print(otherdevices['Altandörr Bak'])
    
    if (devicechanged['Altandörr Bak'] ~= nil) then
        if (devicechanged['Altandörr Bak'] == 'On') then
            commandArray['SendNotification']='Dörr#Altandörr Bak Öppen ' .. currentTimeString ..'!##0'    
        else
            commandArray['SendNotification']='Dörr#Altandörr Bak Stängs ' .. currentTimeString ..'!##0'    
        end
    end

end

return commandArray
