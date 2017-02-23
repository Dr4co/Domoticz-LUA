-- Title: Security Devices: Security Panel (ARM with RFID)
-- Date: 2017-02-23
-- This script switches the Alarm Status according to the alarm panel (RFID),
-- after a certain ARM_DELAY has been reache!

-- NOTE! In case the Security Panel Device (Delay in Settings) is greater than zero.
-- The Security Panel will be ARMED after SUM ("ARM_DELAY" + "Delay") seconds.

commandArray = {}
 
currentTime = os.time() --get date/time right now in seconds

-- Turn on debugging by changing this variable to {true}, otherwise {false}.
DEBUG_MODE = false

-- Your RFID Device Name
RFID_DEVICE_NAME = 'RFID Alarm Level'

-- ARM Delay in total number of seconds
ARM_DELAY = 15

if (devicechanged ~= nil) then
    tc=next(devicechanged)
    Panel=tostring(tc)
else
    Panel=''
end

if (Panel == RFID_DEVICE_NAME) then
    if (devicechanged[Panel] == 'On') then
        print(RFID_DEVICE_NAME .. " was turned on! AlarmPanel will be set to 'Arm Away' in "
            .. ARM_DELAY .. " seconds! (Excluding Security Panel Delay)")
        -- Security Device Delay, under Settings may be set.
        -- In that case, the Security Device will be ARMED after
        -- SUM ("ARM_DELAY" + "Delay (Settings)") [seconds].
    else
        print('AlarmPanel Disarm')
        commandArray['Security Panel'] = 'Disarm'
        commandArray['RFID Ack'] = 'On' --Undersök mera.. :)
    end
end

-- Debug Purposes - Print out the current status of the global variable 'Security'
if (DEBUG_MODE) then
    print("globalvariables['Security']: " .. globalvariables['Security'])
end

-- If the RFID Device is turned on
-- Make sure that the Security Panel is not ARMED until the "ARM_DELAY"
-- has been reached!
if (otherdevices[RFID_DEVICE_NAME] == 'On') then
    
    RFIDString = otherdevices_lastupdate[RFID_DEVICE_NAME]

    year = string.sub(RFIDString, 1, 4)
    month = string.sub(RFIDString, 6, 7)
    day = string.sub(RFIDString, 9, 10)
    hour = string.sub(RFIDString, 12, 13)
    minutes = string.sub(RFIDString, 15, 16)
    seconds = string.sub(RFIDString, 18, 19)
    RFIDLastUpdateTime = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    
    if (DEBUG_MODE) then
        print("RFIDString: " .. RFIDString)
        print("RFIDLastUpdateTime: " .. RFIDLastUpdateTime)
    end
    
    difference = os.difftime(currentTime, RFIDLastUpdateTime)
    
    -- Debug Purposes - Difference in seconds between current time and RFID last update time
    if (DEBUG_MODE) then
        print("Difference: " .. difference) 
    end
    
    if (difference > ARM_DELAY) then
        -- Avaiable globalvariables['Security'] = 'Disarmed', 'Armed Home' or 'Armed Away'
        if (globalvariables['Security'] == 'Disarmed') then
            commandArray['Security Panel'] = 'Arm Away'
            print("Turn on the panel!")
        end
    end

    if (DEBUG_MODE) then
        print("otherdevices['RFID Alarm Level']: " .. otherdevices[RFID_DEVICE_NAME])
    end
end
return commandArray
