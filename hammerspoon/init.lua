hs.application.enableSpotlightForNameSearches(true)

local function toggleApp(settings)
	hs.hotkey.bind(settings.mods, settings.key, function()
		local app = hs.application.find(settings.app)
		if app ~= nil and app:isFrontmost() then
			app:hide()
		else
			hs.application.launchOrFocus("/Applications/" .. settings.app .. ".app")
		end
	end)
end

toggleApp({
	app = "Alacritty",
	mods = { "cmd", "alt" },
	key = "`",
})

toggleApp({
	app = "Slack",
	mods = { "cmd", "shift" },
	key = "s",
})

toggleApp({
	app = "Chrome",
	mods = { "cmd", "alt" },
	key = "1",
})
