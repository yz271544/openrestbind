LJ
�    '   6 9  B  X� 9' B 9B 9' ' B  X�L 6	 9
6	 9' B' L )2663267a-4d64-4c60-97c3-cb7d1bdaab368Failed to get system UUID, return default bind codeERRlogngx%s+	gsub
close*a	read
popenio.sudo dmidecode -s system-uuid 2>/dev/null�   +4  6  9  ' B  X�6 96 9'   BL  9BX�	 9'
	 B  X	�  X		� 9	'
 B	 9
'
 B
<
	ER� 9BL 
close^%s*(.-)%s*$([^=]+)=([^=]+)
match
lines!Failed to open config file: ERRlogngxr	openio�  '    ' &6 9 B  X� 9' B4  9B ?  : X�+  L L X�+  L K  
close*a	read
popenio jingwei0226-/usr/local/openresty/bin/IceCode.exe -d ���� �   -   '  B 9 -  B- B+  X�+ 6 9' =X�6 9' =L �� �License check failedJINGWEIlicense_check_resultctxngxbind_uuid-/usr/local/openresty/nginx/conf/bind.ini�  	 -   B    X	�6  9' =6  9' BX�6  9' =6  9' B6  96  9BK  �HTTP_OK	exitA{"code": 400, "msg": "error", "data": "License验证失败"}C{"code": 200, "msg": "success", "data": "License验证通过"}say$application/json; charset=utf-8Content-Typeheaderngx�  )-  B  X�6  9' =6  996  9=6  9  BX�6  9'	 =6  6  9=
6  9' 6  99' B6  96  9BK  �	exit"}license_check_resultctx,{"code": 200, "msg": "error", "data": "sayHTTP_FORBIDDENstatus$application/json; charset=utf-8Content-Type	execproxy_passbackendvarJINGWEILICENSECHECKheaderngx�   .6   9  9     X�6  96  9'   ' B-  BX�  X�- BX�  9 '	 B  X�- '
 BX�  9 ' B  X�- ' BX�6  9' D K  ���@static_files	exec@backend_gis_server_anbao^/gis_server_anbao@backend_prod_api^/prod%-api	find/api/check_container only license checkIgnore uri: 	INFOlogurivarngx: 	  3   3 3 3 3 3 3  B2  �K          