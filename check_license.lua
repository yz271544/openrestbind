local result = ngx.ctx.license_check_result

if result == "JINGWEI" then
    ngx.header["LICENSECHECK"] = "JINGWEI"
    local backend_server = ngx.var.backend    
    ngx.var.proxy_pass = backend_server
    ngx.exec("@backend_prod_api")
else
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say(result)
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
