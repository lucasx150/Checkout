return function (name: string, pattern: string | {string}): boolean
	if type(pattern) == "string" then
		return string.match(name, pattern) ~= nil
	end
	for _, singlePattern in pattern do
		if string.match(name, singlePattern) then
			return true
		end
	end
	return false
end