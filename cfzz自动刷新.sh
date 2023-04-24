#!/bin/bash
# CF中转IP
#设置网络监测节点名称(pushplus提醒作用,非必要参数)
isp=上海电信
#设置plusplus token密钥(pushplus提醒作用,非必要参数)
token=你的密钥
#设置plusplus是否启用(0不启用,1启用 如需启用需要设置token才能正常工作)
pushplus=1
#设置tls是否启用(0不启用,1启用)
tls=1
#设置最小速度kB/s
speed=2000
#设置中转本地端口
local_port=8443
#设置中转目标端口
remote_port=443
while true
do
	startdate=$(date -u -d"+8 hour" +'%Y%m%d')
	./iptest-linux-arm -port=$remote_port
	for i in `grep ms ip.csv | awk -F, '{print $1,$7}' | awk '$2 > $speed {print $1}'`
	do
		if [ "$(date -u -d"+8 hour" +'%Y%m%d')" == "$startdate" ]
		then
			screen -S gostnat -X quit
			sleep 2
			screen -dmS gostnat ./gost -L=scheme://:$local_port/$i:$remote_port
			if [ $pushplus == 1 ]
			then
				curl --location --request POST 'https://www.pushplus.plus/send' --header 'Content-Type: application/json' --data-raw '{"token":"'"$token"'","title":"'"$isp"'中转IP通知","content":"切换到中转IP '"$i"'\n","template":"txt"}'
			fi
			echo 进入状态监测
			starttime=$(date +%s)
			while true
			do
				if [ "$(date -u -d"+8 hour" +'%Y%m%d')" == "$startdate" ]
				then
					if [ $tls == 1 ]
					then
						http_code=$(curl -A "" --resolve cp.cloudflare.com:$remote_port:$i -s https://cp.cloudflare.com:$remote_port -w %{http_code} --connect-timeout 2 --max-time 3)
					else
						http_code=$(curl -A "" -x $1:$remote_port -s http://cp.cloudflare.com:$remote_port -w %{http_code} --connect-timeout 2 --max-time 3)
					fi
					if [ "$http_code" != "204" ]
					then
						echo "$(date +'%H:%M:%S') $i 发生故障"
						endtime=$(date +%s)
						if [ $pushplus == 1 ]
						then
							curl --location --request POST 'https://www.pushplus.plus/send' --header 'Content-Type: application/json' --data-raw '{"token":"'"$token"'","title":"'"$i"' 无法访问","content":"故障时间：'"$(date +'%Y-%m-%d %H:%M:%S')"'\n故障IP：'"$i"'\n故障原因：无法连接服务器\n监测节点：'"$isp"'\n存活时间：'"$[$endtime-$starttime]"' 秒","template":"txt"}'
						fi
						break
					else
						echo "$(date +'%H:%M:%S') $i 状态正常"
						sleep 5
					fi
				else
					break
				fi
			done
		else
			break
		fi
	done
done
