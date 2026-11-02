dnf -y -q install setools-console >/dev/null 2>&1
echo "== ports"; for p in 8300 8301 8302 8400 8500 8600 2379 2380 6432 8008; do echo "$p: $(semanage port -l | awk -v p=$p '{for(i=3;i<=NF;i++){gsub(",","",$i); split($i,r,"-"); if ($i==p || (r[2]!="" && p>=r[1] && p<=r[2])) print $1"/"$2}}' | sort -u | tr '\n' ' ')"; done
echo "== fcontexts"; for p in /usr/libexec/keepalived /usr/libexec/keepalived/haproxy_check.sh /usr/sbin/keepalived /etc/keepalived /usr/local/bin/consul /etc/consul /etc/consul.d /opt/consul /var/log/consul /run/consul /usr/local/bin/wal-g /var/lib/pgsql/.walg.json /etc/patroni /usr/bin/vip-manager; do echo "$p $(matchpathcon -n $p 2>&1)"; done
echo "== keepalived script domain"; sesearch -T -s keepalived_t -c process
echo "== keepalived booleans"; getsebool -a | grep -i keepalived
echo "== interfaces"; grep -h "^interface(\`\(corenet_tcp_bind_all_unreserved_ports\|corenet_udp_bind_all_unreserved_ports\|corenet_tcp_connect_all_unreserved_ports\|sysnet_dns_name_resolve\|corenet_rw_tun_tap_dev\|init_stream_connect\|systemd_exec_systemctl\|corenet_port\|cron_system_entry\|files_pid_filetrans\|files_config_file\)'" -r /usr/share/selinux/devel/include | sort -u
