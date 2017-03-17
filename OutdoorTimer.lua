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

-- Domoticz: Date & Time / Sunrise / Sunset
-- 2017-03-17 21:52:42 ☀▲05:57 ▼17:53

-- TIP:
-- 17*60 + 53 = 1073 = timeofday['SunsetInMinutes']

-- 2017-03-17 22:01:33.955 EventSystem: reset all events...
-- 2017-03-17 22:01:39.876 LUA: timenow.min: 1
-- 2017-03-17 22:01:39.876 LUA: timenow.hour: 22
-- 2017-03-17 22:01:39.876 LUA: minutesnow:1321
-- 2017-03-17 22:01:39.876 LUA: timeofday['SunsetInMinutes']: 1073
-- 2017-03-17 22:01:39.845 (Z-Stick) Lux (Fibaro Lux)
-- 2017-03-17 22:01:43.064 LUA: timenow.min: 1
-- 2017-03-17 22:01:43.064 LUA: timenow.hour: 22
-- 2017-03-17 22:01:43.064 LUA: minutesnow:1321
-- 2017-03-17 22:01:43.064 LUA: timeofday['SunsetInMinutes']: 1073

-- Get current time
timenow = os.date("*t")
minutesnow = timenow.min + timenow.hour * 60

if (DEBUG) then
    print("timenow.min: " .. timenow.min)
    print("timenow.hour: " .. timenow.hour)

    print("minutesnow:" .. minutesnow)
    print("timeofday['SunsetInMinutes']: " .. timeofday['SunsetInMinutes'])
    
    -- test for sunset + 18 minutes
end

-- Turn on the FRONT outdoor light "After Sunset" + 18 minutes
-- Everyday! By design!
-- Since no condition is added to check weekday/weekend at the moment...
if (minutesnow == timeofday['SunsetInMinutes'] + 18) then
    if (otherdevices['Utomhus Switch'] ~= 'On') then
        commandArray['Utomhus Switch'] = 'On'
    end
end

-- Domoticz: Date & Time / Sunrise / Sunset
-- 2017-03-17 21:52:42 ☀▲05:57 ▼17:53

-- TIP:
-- 357 % 60 = 5h + 57 => 5:57 = timeofday['SunriseInMinutes']
-- 2017-03-17 22:16:36.346 LUA: timeofday['SunriseInMinutes']: 357

if (DEBUG) then    
    print("timeofday['SunriseInMinutes']: " .. timeofday['SunriseInMinutes'])
end

-- Turn on the FRONT outdoor light "Before Sunrise" - 15 minutes
-- Everyday! By design!
-- Since no condition is added to check weekday/weekend at the moment...
--if (minutesnow == timeofday['SunriseInMinutes'] - 15) then
if (minutesnow == timeofday['SunriseInMinutes'] - 15) then
    if (otherdevices['Utomhus Switch'] ~= 'Off') then
        commandArray['Utomhus Switch'] = 'Off'
    end
end

return commandArray
