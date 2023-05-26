@echo off

title IP �� DNS �����л�
color 0a

rem ���¼��������û���������

rem name���ֵ����������������ӵ����ƣ�
rem ��Ҫ��������������ȥ�鿴    
rem �󲿷�nameֵ���ǡ��������ӡ���
rem ��Ҫ�������Լ��������޸�����

set NAME="��̫��"
set IP=192.168.10.42
set MASK=255.255.255.0    
set GATEWAY=192.168.10.1
set DNS1=119.29.29.29
set DNS2=223.6.6.6

rem ���ϼ��������û�����������



:start

cls

echo =========================IP �� DNS �����л�=============================

echo.

echo    *** ����������Կ����л��Լ����ɶ��� IP �� DNS ���� ***
echo    *** ��������ܶ�������Զ���, ������Ҫ�����޸� ***
echo    *** ע�⣺������Ҫ ����ԱȨ�� ***
echo.

echo    1. �鿴������ǰ�������ò���
echo    2. �Զ����IP---�Զ����DNS
echo    3. �Զ����IP---�ֶ�����DNS
echo    4. �ֶ�����IP---�ֶ�����DNS(����)
echo    5. �˳�......

echo.
echo =========================IP �� DNS �����л�=============================
echo.


set /P action=��ѡ������������š�1-5����

if /I "%action%"=="1" goto :1

if /I "%action%"=="2" goto :2

if /I "%action%"=="3" goto :3

if /I "%action%"=="4" goto :4

if /I "%action%"=="5" goto :5


goto :start


rem �������˵�

:main

cls

goto :start


rem �鿴������ǰ�������ò���

:1

cls

ipconfig /all

echo ��������������˵�...

pause >nul

goto :start


rem �Զ����IP---�Զ����DNS

:2

cls

echo ����ģʽ���Զ����IP---�Զ����DNS

echo ���ڴ�DHCP�Զ���ȡIP��ַ...    

netsh interface ip set address %NAME% dhcp    

echo ���ڴ�DHCP�Զ���ȡDNS��ַ...    

netsh interface ip set dns %NAME% dhcp     

echo ��̬DNS������ɣ���������������˵�...

pause > nul

goto :main





rem �Զ����IP---�ֶ�����DNS

:3

cls

echo ����ģʽ���Զ����IP---�ֶ�����DNS

echo ���ڴ�DHCP�Զ���ȡIP��ַ...    

netsh interface ip set address %NAME% dhcp    

echo ��ѡDNS = %DNS1%     

netsh interface ipv4 set dns name=%NAME% source=static addr=%DNS1% register=PRIMARY >nul     

echo ����DNS = %DNS2%     

netsh interface ipv4 add dns name=%NAME% addr=%DNS2% index=2 >nul    

echo ��̬DNS������ɣ���������������˵�...

pause > nul

goto :main





rem �ֶ�����IP---�ֶ�����DNS

:4

cls

echo ����ģʽ���ֶ�����IP---�ֶ�����DNS

echo IP��ַ = %IP%    

echo �������� = %MASK%    

echo Ĭ������ = %GATEWAY%    

netsh interface ipv4 set address name=%NAME% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=0 >nul    

echo ��ѡDNS = %DNS1%     

netsh interface ipv4 set dns name=%NAME% source=static addr=%DNS1% register=PRIMARY >nul     

echo ����DNS = %DNS2%     

netsh interface ipv4 add dns name=%NAME% addr=%DNS2% index=2 >nul     

echo ��̬DNS������ɣ���������������˵�...

pause > nul

goto :main



:5

exit
