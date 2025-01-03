local hammerspoonDir = os.getenv("HOME") .. "/.hammerspoon/"

configWatcher = hs.pathwatcher.new(hammerspoonDir, function(files)
	local shouldReload = false

	for _, file in pair(files) do
		if file:sub(-4) == ".lua" then
			shouldReload = true
		end
	end

	if shouldReload then
		hs.reload()
	end
end)

configWatcher:start()
