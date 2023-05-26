@echo off

title IP 和 DNS 快速切换
color 0a

rem 以下几个参数用户自行配置

rem name这个值，是你电脑网络连接的名称，
rem 需要到网络适配器中去查看    
rem 大部分name值都是”本地连接”，
rem 需要根据你自己的配置修改名称

set NAME="以太网"
set IP=192.168.10.42
set MASK=255.255.255.0    
set GATEWAY=192.168.10.1
set DNS1=119.29.29.29
set DNS2=223.6.6.6

rem 以上几个参数用户请自行配置



:start

cls

echo =========================IP 和 DNS 快速切换=============================

echo.

echo    *** 本批处理可以快速切换以及自由定制 IP 和 DNS 设置 ***
echo    *** 本批处理很多参数可以定制, 若有需要自行修改 ***
echo    *** 注意：运行需要 管理员权限 ***
echo.

echo    1. 查看本机当前网络配置参数
echo    2. 自动获得IP---自动获得DNS
echo    3. 自动获得IP---手动设置DNS
echo    4. 手动设置IP---手动设置DNS(宿舍)
echo    5. 退出......

echo.
echo =========================IP 和 DNS 快速切换=============================
echo.


set /P action=请选择输入命令序号【1-5】：

if /I "%action%"=="1" goto :1

if /I "%action%"=="2" goto :2

if /I "%action%"=="3" goto :3

if /I "%action%"=="4" goto :4

if /I "%action%"=="5" goto :5


goto :start


rem 返回主菜单

:main

cls

goto :start


rem 查看本机当前网络配置参数

:1

cls

ipconfig /all

echo 按任意键返回主菜单...

pause >nul

goto :start


rem 自动获得IP---自动获得DNS

:2

cls

echo 工作模式：自动获得IP---自动获得DNS

echo 正在从DHCP自动获取IP地址...    

netsh interface ip set address %NAME% dhcp    

echo 正在从DHCP自动获取DNS地址...    

netsh interface ip set dns %NAME% dhcp     

echo 动态DNS设置完成，按任意键返回主菜单...

pause > nul

goto :main





rem 自动获得IP---手动设置DNS

:3

cls

echo 工作模式：自动获得IP---手动设置DNS

echo 正在从DHCP自动获取IP地址...    

netsh interface ip set address %NAME% dhcp    

echo 首选DNS = %DNS1%     

netsh interface ipv4 set dns name=%NAME% source=static addr=%DNS1% register=PRIMARY >nul     

echo 备用DNS = %DNS2%     

netsh interface ipv4 add dns name=%NAME% addr=%DNS2% index=2 >nul    

echo 静态DNS设置完成，按任意键返回主菜单...

pause > nul

goto :main





rem 手动设置IP---手动设置DNS

:4

cls

echo 工作模式：手动设置IP---手动设置DNS

echo IP地址 = %IP%    

echo 子网掩码 = %MASK%    

echo 默认网关 = %GATEWAY%    

netsh interface ipv4 set address name=%NAME% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=0 >nul    

echo 首选DNS = %DNS1%     

netsh interface ipv4 set dns name=%NAME% source=static addr=%DNS1% register=PRIMARY >nul     

echo 备用DNS = %DNS2%     

netsh interface ipv4 add dns name=%NAME% addr=%DNS2% index=2 >nul     

echo 静态DNS设置完成，按任意键返回主菜单...

pause > nul

goto :main



:5

exit
