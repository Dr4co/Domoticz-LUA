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

currentTimeString = os.date("%Y-%m-%d %H:%M:%S") 

if (DEBUG) then
    print("otherdevices['Smoke | Förrådet']: " .. otherdevices['Smoke | Förrådet'])
end

for i, v in pairs(otherdevices) do
   
    tc = tostring(i)
    v = i:sub(1,5)
    if (v == 'Smoke') then
        if (DEBUG) then
            print("i: " .. i)
            print("otherdevices[" .. i .. "]: " .. otherdevices[i])
        end
      
        if (otherdevices[i] ~= 'Normal') then
            -- or devicechanged[i] == 'Panic'
            commandArray['SendNotification']='BRAND!#Det brinner ' .. i .. ' ' .. currentTimeString ..'!##0'
            
            -- TODO: Add some logic to modify the different notifications depending on which Smoke device,
            -- has been triggered.
        end
   end
end

return commandArray
