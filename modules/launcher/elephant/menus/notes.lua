Name = "notes"
NamePretty = "Notes"
Cache = false
HideFromProviderlist = false
SearchName = true
FixedOrder = true

function stringToFilename(str)
    if str == nil then return nil end
    local encoded = string.gsub(str, "([^%w_.-])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return encoded
end


function filenameToString(str)
    if str == nil then return nil end
    local decoded = string.gsub(str, "%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
    return decoded
end

function GetStateDir()
	local home = os.getenv("HOME")
	local stateDir =  home .. '/.local/state/aether/notes'
	return stateDir
end

function GetEntries()

	local entries = {}
	local stateDir = GetStateDir()

	os.execute('mkdir -p "' .. stateDir .. '"')

	table.insert(entries, {
	    Text = "Add new",
	    Actions = {
	        add = "lua:Add",
	    },
	    Icon = "list-add-symbolic",
	    Preview = "Type '?' followed by your note title or leave it blank to open the notes directory.",
        PreviewType = "text",
	})


	local handle = io.popen('find "' .. stateDir .. '" -type f -printf "%T@ %p\\n" | sort -nr | sed \'s/^[0-9.]* //\'')
	if handle then
		for file in handle:lines() do
			local filename = string.gsub(file, "^.*[/]", "")
		    local f = io.open(file, "r")
		    if f then
		        local content = f:read("*a")
		        f:close()
		        table.insert(entries, {
	               Text = filenameToString(filename),
	               Value = file,
	               Actions = {
	                   delete = "lua:Delete",
	                   copy = "lua:Copy",
	                   edit = "lua:Edit"
	               },
	               Preview = content,
	               PreviewType = "text",
	               Icon = "text-x-generic-symbolic"
	           })
		    end
		end
	end

	handle:close()
    return entries
end


function Edit(value, args)
    os.execute('xdg-open "' .. value .. '"')
end

function Copy(value, args)
	os.execute('cat "' .. value .. '" | wl-copy')
end

function Delete(value, args)
    os.execute('rm "' .. value .. '"')
end

function Add(value, args)
	local stateDir = GetStateDir()
	local filename = stringToFilename(args)
	local file = '"' .. stateDir .. '/' .. filename .. '"'
  	os.execute('touch -a ' .. file)
  	os.execute('xdg-open ' .. file)
end
