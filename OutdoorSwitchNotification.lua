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

DEBUG = false;

if (devicechanged ~= nil) then

    currentTimeString = os.date("%Y-%m-%d %H:%M:%S") 

    AlarmIsArmed = false;
    DisableNotifications = false;
    
    if(globalvariables['Security'] == 'Armed Away') then
        AlarmIsArmed = true;
    end
    
    if (otherdevices['Presence'] == 'On') then
        DisableNotifications = true;
    end
    
    if (devicechanged['Utomhus Switch'] ~= nil) then
        
        -- Syntax: The total command is:
        --- commandArray['SendNotification']='subject#body#extraData#priority#sound'
        commandArray['SendNotification']='Utomhus#Utomhus Swich ' .. devicechanged['Utomhus Switch'] .. ' ' .. currentTimeString ..'!##0'
    end

    --[[
        Only send DOOR notifications if the Alarm Panel is set to 'Arm Away'.
        
        'Dummy' switch named 'Presence', will manually override the notifications,
        and disable notifications, as long as it is 'On'.
        
        Unless the Alarm Panel is set to 'Arm Away', then DOOR notifications shall
        always be received!
    --]]
    if (AlarmIsArmed or not DisableNotifications) then
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

        if (devicechanged['Altandörr Bak'] ~= nil) then
            if (devicechanged['Altandörr Bak'] == 'On') then
                commandArray['SendNotification']='Dörr#Altandörr Bak Öppen ' .. currentTimeString ..'!##0'    
            else
                commandArray['SendNotification']='Dörr#Altandörr Bak Stängs ' .. currentTimeString ..'!##0'    
            end
        end
    end
end

return commandArray
