hs.application.enableSpotlightForNameSearches(true)

hs.hotkey.bind({ "cmd", "alt" }, "`", function()
	local alacritty = hs.application.find("Alacritty")
	if alacritty ~= nil and alacritty:isFrontmost() then
		alacritty:hide()
	else
		hs.application.launchOrFocus("/Applications/Alacritty.app")
	end
end)
