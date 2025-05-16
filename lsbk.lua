local function get_system_arch()
	local command = "arch 2>/dev/null"
	local handle = io.popen(command)
	if handle then
		local result = handle:read("*a")
		handle:close()
		result = result:gsub("%s+", "")
		if result ~= "" then
			return result
		end
	end
	ngx.log(ngx.ERR, "Failed to get system arch, return default arch")
	return "x86_64"
end

local function get_system_uuid()
	local command = "sudo dmidecode -s system-uuid 2>/dev/null"
	local handle = io.popen(command)
	if handle then
		local result = handle:read("*a")
		handle:close()
		result = result:gsub("%s+", "")
		if result ~= "" then
			return result
		end
	end
	ngx.log(ngx.ERR, "Failed to get system UUID, return default bind code")
	return "2663267a-4d64-4c60-97c3-cb7d1bdaab36"
end

local function load_ini_config(file_path)
	local config = {}
	local file = io.open(file_path, "r")
	if not file then
		ngx.log(ngx.ERR, "Failed to open config file: ", file_path)
		return config
	end
	for line in file:lines() do
		local key, value = line:match("([^=]+)=([^=]+)")
		if key and value then
			config[key:match("^%s*(.-)%s*$")] = value:match("^%s*(.-)%s*$")
		end
	end
	file:close()
	return config
end

local function decode_bind_uuid(bind_uuid)
	local systemArch = get_system_arch()
	local command = "/usr/local/openresty/bin/IceCode.exe -d " .. bind_uuid .. " jingwei0226"
	if systemArch == "aarch64" then
		command = "/usr/local/openresty/bin/IceCodeAarch64.exe -d " .. bind_uuid .. " jingwei0226"
	end
	ngx.log(ngx.INFO, "systemArch: ", systemArch, " command: ", command)
	local file = io.popen(command)
	if file then
		local decode_uuid = file:read("*a")
		local status = { file:close() }
		if status[3] ~= 0 then
			return nil
		end
		return decode_uuid
	else
		return nil
	end
end

local function license_check()
	local config = load_ini_config("/usr/local/openresty/nginx/conf/bind.ini")
	local bind_uuid = config["bind_uuid"]
	local decode_buuid = decode_bind_uuid(bind_uuid)
	local real_uuid = get_system_uuid()

	local license_check_passed = false
	if decode_buuid == real_uuid then
		license_check_passed = true
		ngx.ctx.license_check_result = "JINGWEI"
	else
		ngx.ctx.license_check_result = "License check failed"
	end
	return license_check_passed
end

local function handle_container_validation()
	local license_passed = license_check()
	if license_passed then
		ngx.header["Content-Type"] = "application/json; charset=utf-8"
		ngx.say('{"code": 200, "msg": "success", "data": "License验证通过"}')
	else
		ngx.header["Content-Type"] = "application/json; charset=utf-8"
		ngx.say('{"code": 400, "msg": "error", "data": "License验证失败"}')
	end
	ngx.exit(ngx.HTTP_OK)
end

local function handle_protected_route(backend_location)
	local license_passed = license_check()
	if license_passed then
		ngx.header["LICENSECHECK"] = "JINGWEI"
		local backend_server = ngx.var.backend
		ngx.var.proxy_pass = backend_server
		ngx.exec(backend_location)
	else
		ngx.header["Content-Type"] = "application/json; charset=utf-8"
		ngx.status = ngx.HTTP_FORBIDDEN
		ngx.say('{"code": 200, "msg": "error", "data": "', ngx.ctx.license_check_result, '"}')
		ngx.exit(ngx.HTTP_FORBIDDEN)
	end
end

local function main()
	local uri = ngx.var.uri
	if uri == nil then
		ngx.log(ngx.INFO, "Ignore uri: ", uri, " only license check")
		license_check()
	elseif uri == "/api/check_container" then
		handle_container_validation()
	elseif uri:find("^/prod%-api") then
		handle_protected_route("@backend_prod_api")
	elseif uri:find("^/gis_server_anbao") then
		handle_protected_route("@backend_gis_server_anbao")
	else
		return ngx.exec("@static_files")
	end
end

main()
