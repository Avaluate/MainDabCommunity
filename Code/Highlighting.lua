local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}
local global_env = {"game", "workspace", "script", "math", "string", "require", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "tostring", "type", "typeof", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16"}

local Source = script.Parent.Main
local Lines = Source.Parent.Sidelines

local Highlight = function(string, keywords)
	local K = {}
	local S = string
	local Token =
		{
			["="] = true,
			["."] = true,
			[","] = true,
			["("] = true,
			[")"] = true,
			["["] = true,
			["]"] = true,
			["{"] = true,
			["}"] = true,
			[":"] = true,
			["*"] = true,
			["/"] = true,
			["+"] = true,
			["-"] = true,
			["%"] = true,
			[";"] = true,
			["~"] = true
		}
	for i, v in pairs(keywords) do
		K[v] = true
	end
	S = S:gsub(".", function(c)
		if Token[c] ~= nil then
			return "\32"
		else
			return c
		end
	end)
	S = S:gsub("%S+", function(c)
		if K[c] ~= nil then
			return c
		else
			return (" "):rep(#c)
		end
	end)

	return S
end

local hTokens = function(string)
	local Token =
		{
			["="] = true,
			["."] = true,
			[","] = true,
			["("] = true,
			[")"] = true,
			["["] = true,
			["]"] = true,
			["{"] = true,
			["}"] = true,
			[":"] = true,
			["*"] = true,
			["/"] = true,
			["+"] = true,
			["-"] = true,
			["%"] = true,
			[";"] = true,
			["~"] = true
		}
	local A = ""
	string:gsub(".", function(c)
		if Token[c] ~= nil then
			A = A .. c
		elseif c == "\n" then
			A = A .. "\n"
		elseif c == "\t" then
			A = A .. "\t"
		else
			A = A .. "\32"
		end
	end)

	return A
end


local strings = function(string)
	local highlight = ""
	local quote = false
	string:gsub(".", function(c)
		if quote == false and c == "\"" then
			quote = true
		elseif quote == true and c == "\"" then
			quote = false
		end
		if quote == false and c == "\"" then
			highlight = highlight .. "\""
		elseif c == "\n" then
			highlight = highlight .. "\n"
		elseif c == "\t" then
			highlight = highlight .. "\t"
		elseif quote == true then
			highlight = highlight .. c
		elseif quote == false then
			highlight = highlight .. "\32"
		end
	end)

	return highlight
end

local comments = function(string)
	local ret = ""
	string:gsub("[^\r\n]+", function(c)
		local comm = false
		local i = 0
		c:gsub(".", function(n)
			i = i + 1
			if c:sub(i, i + 1) == "--" then
				comm = true
			end
			if comm == true then
				ret = ret .. n
			else
				ret = ret .. "\32"
			end
		end)
		ret = ret
	end)

	return ret
end

local numbers = function(string)
	local A = ""
	string:gsub(".", function(c)
		if tonumber(c) ~= nil then
			A = A .. c
		elseif c == "\n" then
			A = A .. "\n"
		elseif c == "\t" then
			A = A .. "\t"
		else
			A = A .. "\32"
		end
	end)

	return A
end

local highlight_source = function(type)
	if type == "Text" then
		Source.Text = Source.Text:gsub("\13", "")
		Source.Text = Source.Text:gsub("\t", "      ")
		local s = Source.Text
		Source.KE.Text = Highlight(s, lua_keywords)
		Source.GN.Text = Highlight(s, global_env)
		Source.Royale.Text = Highlight(s, {""})
		Source.Cat.Text = hTokens(s)
		Source.Mrow.Text = numbers(s)
		Source.Meow.Text = strings(s)
		Source.Talk.Text = comments(s)
		local lin = 1
		s:gsub("\n", function()
			lin = lin + 1
		end)
		Lines.Text = ""
		for i = 1, lin do
			Lines.Text = Lines.Text .. i .. "\n"
		end
	end
end

highlight_source("Text")

Source.Changed:Connect(highlight_source)
