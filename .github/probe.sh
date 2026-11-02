dnf -y -q install setools-console selinux-policy-devel >/dev/null 2>&1
echo "== policy"; rpm -q selinux-policy-targeted
echo "== types"; seinfo -t | grep -iE 'etcd|pgbouncer|haproxy|consul|keepalived|confd|vip|pgbackrest|walg|postgresql_' | sort
echo "== ports"; semanage port -l | grep -E '\b(2379|2380|6432|8008|8500|8300|8301|5000|5001|5002|5003|7000)\b'
echo "== port types"; semanage port -l | grep -iE 'etcd|pgbouncer|haproxy|consul|postgres|commplex|http_port'
echo "== interface files"; ls /usr/share/selinux/devel/include/contrib | grep -iE 'etcd|pgbouncer|haproxy|keepalived|consul|rhcs|postgres|cluster' 
echo "== fcontexts"; for p in /usr/bin/pgbackrest /var/lib/pgbackrest /var/log/pgbackrest /etc/pgbackrest /tmp/pgbackrest /usr/bin/pgbouncer /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer /usr/local/bin/etcd /usr/bin/etcd /var/lib/etcd /etc/etcd /usr/local/bin/confd /etc/confd /usr/bin/vip-manager /usr/sbin/haproxy /etc/haproxy /usr/local/bin/wal-g; do echo "$p $(matchpathcon -n $p 2>&1)"; done
echo "== postgresql_t network"; sesearch -A -s postgresql_t -c tcp_socket -p name_connect
echo "== postgresql_t exec"; sesearch -A -s postgresql_t -c file -p execute | head -30
echo "== postgresql_t transitions"; sesearch -T -s postgresql_t -c process
echo "== booleans"; getsebool -a | grep -iE 'postgres|haproxy|nis_enabled|selinuxuser'
echo "== pgbouncer interfaces"; grep -l -i pgbouncer -r /usr/share/selinux/devel/include | head
