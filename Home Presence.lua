-- Check the wiki for dzVents: https://www.domoticz.com/wiki/DzVents:_next_generation_LUA_scripting
-- remove what you don't need
return {

	-- optional active section,
	-- when left out the script is active
	-- note that you still have to check this script
	-- as active in the side panel
	active = {
		true,  -- either true or false, or you can specify a function
	},
	on = {
		-- device triggers
		devices = {
			-- scripts is executed if the device that was updated matches with one of these triggers
			'Entrance Burglar', -- device name
			'Basement Burglar'
            -- '*Burglar', -- Alternative trigger for all devices which name ends with the sufix 'Burglar'
		}
	},
	
	-- custom logging level for this script
	logging = {
        -- Script level loggin example (domoticz.LOG_DEBUG / domoticz.LOG_INFO)
        level = domoticz.LOG_INFO,
        marker = "Home presence script"
    },

	-- actual event code
	-- the second parameter is depending on the trigger
	-- when it is a device change, the second parameter is the device object
	-- similar for variables, scenes and groups and httpResponses
	-- inspect the type like: triggeredItem.isDevice
	execute = function(domoticz, device)
	    domoticz.log('Triggered device: ' .. device.name)
	     -- The actual switch you want to toggle if there's movement in the house, e.g. a wall plug
        local THE_SWITCH = domoticz.devices('Entrance Wall Plug')
        local AMOUNT_OF_MINUTES_TO_TURN_ON = 15 -- Turn on the wall plug for 15 minutes
		if (device.state == 'On') then -- state == 'On'
            if (THE_SWITCH.state == 'On') then
                THE_SWITCH.cancelQueuedCommands() -- Cancel all previous queue commnads for the device/switch
                THE_SWITCH.switchOff().afterMin(AMOUNT_OF_MINUTES_TO_TURN_ON) -- Check if on before turning off!
            else
                THE_SWITCH.cancelQueuedCommands() -- Cancel all previous queue commnads for the device/switch
                THE_SWITCH.switchOn().checkFirst().afterMin(AMOUNT_OF_MINUTES_TO_TURN_ON) -- Check if on before turning off!
            end
	    end
	end
}
