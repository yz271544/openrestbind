local function get_system_uuid()
    local command = "sudo dmidecode -s system-uuid 2>/dev/null"
    local handle = io.popen(command)
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result then
            return result:gsub("%s+", "")
        end
    end
    ngx.log(ngx.ERR, "Failed to get system UUID")
    return nil
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
    local command = "/usr/local/openresty/bin/IceCode.exe -d " .. bind_uuid .. " jingwei0226"
    ngx.log(ngx.INFO, "Command: ", command)
    local file = io.popen(command)
    if file then
        local decode_uuid = file:read("*a")
        local status = {file:close()}
        if status[3] ~= 0 then
            ngx.log(ngx.ERR, "Command execution failed with status: ", status[3])
            return nil
        end
        ngx.log(ngx.INFO, "Decoded UUID: ", decode_uuid)
        return decode_uuid
    else
        ngx.log(ngx.ERR, "Failed to execute command")
        return nil
    end
end

local config = load_ini_config("/usr/local/openresty/nginx/conf/bind.ini")
local bind_uuid = config["bind_uuid"]
ngx.log(ngx.INFO, "Bind UUID: ", bind_uuid)
local decode_buuid = decode_bind_uuid(bind_uuid)
ngx.log(ngx.INFO, "Decoded bind UUID: ", decode_buuid)
local real_uuid = get_system_uuid()
ngx.log(ngx.INFO, "Real UUID: ", real_uuid)

local license_check_passed = false
if decode_buuid == real_uuid then
    license_check_passed = true
    ngx.ctx.license_check_result = "JINGWEI"
else
    ngx.ctx.license_check_result = "License check failed"
    ngx.status = ngx.HTTP_FORBIDDEN
end
