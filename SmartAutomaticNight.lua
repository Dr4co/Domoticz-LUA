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

--[[
    Example Block Comment
--]]

--[[
    Flow
    
    Desired Feature: Dummy Switch [1, 2, 3, 4] hours delay.
    
    1) Is it after 22:30?`
        AND
    2) If no activity in ~40 minutes
        AND
    3) If "Sovdags" Switch has not been triggered in MORE than 21-23h.
    
        THEN
    Toggle "Sovdags" Switch
    
    4) Delay - Delay 'Sovdags' with X hours from when it is triggered [Last Updated]
        (If the switch was toggled the same DAY as current DAY (currentTime).
        
        OR
        
    5) Delay 'Sovdags' from original 22:30? + Delay X hours
    
--]]
-- Flow 
-- If Weekday (
--
--

currentTime = os.time() --get date/time right now in seconds

----------------------- LUA Wiki TIME
----------- https://www.lua.org/pil/22.1.html
-- %w	weekday (3) [0-6 = Sunday-Saturday]

-- Turn on debugging by changing this variable to {true}, otherwise {false}.
DEBUG_MODE = true

-- Your RFID Device Name
SWITCH_DEVICE = 'Sovdags'


    SwitchLastUpdateString = otherdevices_lastupdate[SWITCH_DEVICE]

    year = string.sub(SwitchLastUpdateString, 1, 4)
    month = string.sub(SwitchLastUpdateString, 6, 7)
    day = string.sub(SwitchLastUpdateString, 9, 10)
    hour = string.sub(SwitchLastUpdateString, 12, 13)
    minutes = string.sub(SwitchLastUpdateString, 15, 16)
    seconds = string.sub(SwitchLastUpdateString, 18, 19)
    DeviceLastUpdateTime = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}

    --- Last PIR Activity compared to "Current Time", difference is given in seconds.
    function timeSinceLastPIRActivity(currentTime)
        
        --Read last date/time for each device
        PIRUppeLastUpdateTimeString = otherdevices_lastupdate['PIR Uppe Burglar']
        PIRKitchenLastUpdateTimeString = otherdevices_lastupdate['Kitchen Burglar']
        PIRVRumLastUpdateTimeString = otherdevices_lastupdate['V-Rum Burglar']
        
        year = string.sub(PIRUppeLastUpdateTimeString, 1, 4)
        month = string.sub(PIRUppeLastUpdateTimeString, 6, 7)
        day = string.sub(PIRUppeLastUpdateTimeString, 9, 10)
        hour = string.sub(PIRUppeLastUpdateTimeString, 12, 13)
        minutes = string.sub(PIRUppeLastUpdateTimeString, 15, 16)
        seconds = string.sub(PIRUppeLastUpdateTimeString, 18, 19)
        PIRUppeLastUpdateTime = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
        
        year = string.sub(PIRKitchenLastUpdateTimeString, 1, 4)
        month = string.sub(PIRKitchenLastUpdateTimeString, 6, 7)
        day = string.sub(PIRKitchenLastUpdateTimeString, 9, 10)
        hour = string.sub(PIRKitchenLastUpdateTimeString, 12, 13)
        minutes = string.sub(PIRKitchenLastUpdateTimeString, 15, 16)
        seconds = string.sub(PIRKitchenLastUpdateTimeString, 18, 19)
        PIRKitchenLastUpdateTime = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
        
        year = string.sub(PIRVRumLastUpdateTimeString, 1, 4)
        month = string.sub(PIRVRumLastUpdateTimeString, 6, 7)
        day = string.sub(PIRVRumLastUpdateTimeString, 9, 10)
        hour = string.sub(PIRVRumLastUpdateTimeString, 12, 13)
        minutes = string.sub(PIRVRumLastUpdateTimeString, 15, 16)
        seconds = string.sub(PIRVRumLastUpdateTimeString, 18, 19)
        PIRVRumLastUpdateTime = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
        
        -- Last updated PIR device in seconds
        LastUpdateDevice = math.max(PIRUppeLastUpdateTime, PIRKitchenLastUpdateTime, PIRVRumLastUpdateTime)
    
        -- Compare current time with last updated device
        difference = (os.difftime (currentTime, LastUpdateDevice)) 
        
    --    print("SwitchSovdagsLastUpdateTimeString: " .. SwitchSovdagsLastUpdateTimeString)
        
    --    print("currentTime: " .. currentTime)
    --    print("SwitchSovdagsLastUpdateTime: " .. SwitchSovdagsLastUpdateTime)
    --    print("SwitchSovdagsLastUpdateTime: " .. SwitchSovdagsLastUpdateTime)
    --    print("SwitchSovdagsLastUpdateTime + 5h: " .. SwitchSovdagsLastUpdateTime+5*60*60)
        
--        if (currentTime > (SwitchSovdagsLastUpdateTime + 6.5*60*60)) then
--    --        print("IF-statement")
--            
--                --    if (difference > 30*60) and (uservariables[cmd] == 0) then --if device date/time is more than 30 minutes
--            if (difference > 30*60) then --if device date/time is more than 30 minutes        
--            --    file = io.open("sensor.txt", "a") -- Opens a file named sensor.txt(stored under Domoticz folder) in append mode
--            --    commandArray['SendEmail']=''..cmd..' äldre än 40 min#'..s..' är senaste tid#abc@hotmail.com' --send mail
--            end
--        end
        
        return difference
    end
    
if (DEBUG_MODE) then
--        print("SwitchLastUpdateString: " .. SwitchLastUpdateString)
--        print("RFIDLastUpdateTime: " .. DeviceLastUpdateTime)

--        print("difference: " .. (currentTime - DeviceLastUpdateTime) .. " seconds!")    
    -- 2017-02-23 21:49:00.304 LUA: SwitchLastUpdateString: 2017-02-22 22:47:34
    -- 2017-02-23 21:49:00.304 LUA: RFIDLastUpdateTime: 1487800054
    -- 2017-02-23 21:49:00.304 LUA: difference: 82886 seconds!

--        print("Hour: " .. hour)
--        print("minutes: " .. minutes)
    
    -- %w	weekday (3) [0-6 = Sunday-Saturday]
    
    -- 2017-02-23 21:52:44.007 LUA: DeviceLastUpdateTime (weekday): 3
--        print("DeviceLastUpdateTime (weekday): " .. os.date("%w", DeviceLastUpdateTime))
    -- 2017-02-23 21:52:44.007 LUA: currentTime (weekday): 4
--        print("currentTime (weekday): " .. os.date("%w", currentTime))
    
    -- IS Thursday now!
    -- 2017-02-23 21:59:16.913 LUA: It is Thursday today!
    
    -- if (tonumber(os.date("%w", currentTime)) == 4) then
    --    print("It is Thursday today!")
    -- end
    
    --- Weekday = 0 (Sunday), 5 (Friday), 6 (Saturday)
---        if ((tonumber(os.date("%w", currentTime)) == 0) or (tonumber(os.date("%w", currentTime)) == 5)
---            or (tonumber(os.date("%w", currentTime)) == 6)) then
---            print("It is a weekday! Yey!")
---        else
---        --- Weekday (Monday - Thursday)    
---        
---        end

    -- 2017-02-23 21:57:37.554 LUA: It is a weekday! Yey!
    -- Weekday (Fridays are excluded.. =))
    if ((tonumber(os.date("%w", currentTime)) >= 1) and (tonumber(os.date("%w", currentTime)) <= 4)) then
        -- print("It is a weekday! Yey!")

        -- Current Time is more/after 22:25
        -- %M	minute (48) [00-59]
        if ((tonumber(os.date("%H", currentTime)) >= 22) and
            (tonumber(os.date("%M", currentTime)) >= 15)) then
            -- print(">= 22: " .. tonumber(os.date("%H", currentTime)))

            -- It has gone more than X hours [X = 23] since "Sovdags" has been triggered
            if((currentTime - DeviceLastUpdateTime) > 23*60*60) then
                --print("(DeviceLastUpdateTime - currentTime > 18*60*60): " .. (currentTime - DeviceLastUpdateTime))

                --- NOTE! Maybe Time > 23? timeSinceLastPIRActivity could be lower..?
                ---- E.g. 20-25m..?

                -- DO NOT Trigger the "Sovdags" Dummy Swich UNLESS
                -- We have had NO PIR activity for the last X = 35 minutes
                if (timeSinceLastPIRActivity(currentTime) > 35*60) then
                    -- print(timeSinceLastPIRActivity(currentTime))
                    print("No PIR Activity in the last 10 minutes!")

                    --- TOGGLE "Sovdags"
                    print("Smart Automatic Night Script!")
                    
                    -- Send Notification
                    commandArray['SendNotification']='Night#Smart Automatic Night has been triggered ' .. currentTimeString ..'!##0'
                    commandArray["Sovdags"] = "On"
                    
                    -- TODO... Action ON / IN Any PIR in the last 45 MInutes...? Then HOLD!.....
                    -- Trigger LATER!!!
                end
            end
        end
    --end
    -- It is not a weekday! (Fridays are includeded as weekends.. =))
    else
        -- It's a weekend! Yey!    
        -- %H	hour, using a 24-hour clock (23) [00-23]
        if (tonumber(os.date("%H", currentTime)) >= 23) then
            print(">= 23: " .. tonumber(os.date("%H", currentTime)))
            -- TOGGLE Sovdags!? If it hasn't been toggled the last 2x hours!?
        end
    end
end
return commandArray
