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
    return nil
end

local function load_ini_config(file_path)
    local config = {}
    local file = io.open(file_path, "r")
    if not file then
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
    local file = io.popen(command)
    if file then
        local decode_uuid = file:read("*a")
        local status = {file:close()}
        if status[3] ~= 0 then
            return nil
        end
        return decode_uuid
    else
        return nil
    end
end

local config = load_ini_config("/usr/local/openresty/nginx/conf/bind.ini")
local bind_uuid = config["bind_uuid"]
local decode_buuid = decode_bind_uuid(bind_uuid)
local real_uuid = get_system_uuid()

if decode_buuid == real_uuid then
    ngx.ctx.license_check_result = "JINGWEI"
else
    ngx.status = ngx.HTTP_FORBIDDEN
end
