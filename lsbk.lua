local function get_system_uuid()
	local handle = io.popen("sudo dmidecode -s system-uuid 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result then
			return result:gsub("%s+", "") -- 去除换行符和空格
		end
	end
	return nil
end

local function load_ini_config(file_path)
	local config = {}
	for line in io.lines(file_path) do
		local key, value = line:match("([^=]+)=([^=]+)")
		if key and value then
			config[key:match("^%s*(.-)%s*$")] = value:match("^%s*(.-)%s*$") -- 去除空格
		end
	end
	return config
end

local function decode_bind_uuid(bind_uuid)
	local command = "./bin/IceCode.exe -d " .. bind_uuid .. " jingwei0226"
	-- print("command:", command)
	local file = io.popen(command)
	if file then
		local decode_uuid = file:read("*a")
		file:close()
		-- print("decode_uuid:", decode_uuid)
		return decode_uuid
	else
		-- print("无法执行命令")
		return nil
	end
end

-- local config = load_ini_config("bind-error.ini")
local config = load_ini_config("bind.ini")
local bind_uuid = config["bind_uuid"]
-- print("bind_uuid:", bind_uuid)
local decode_buuid = decode_bind_uuid(bind_uuid)
-- print("decode_buuid:", decode_buuid)
local real_uuid = get_system_uuid()
-- print("real uuid:", real_uuid)

if decode_buuid == real_uuid then
	print("export BIND_MACHINE=true")
	os.exit(0)
else
	os.exit(1)
end
