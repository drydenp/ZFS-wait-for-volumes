# Simple makefile for this service

# Change directories as required

systemddir := /etc/systemd/system
scriptdir := /lib/zfs
services := zfs-volumes.target zfs-wait-for-zvol.service
scripts := zfs-wait

files := $(services) $(scripts)

install: $(files)
	install -o root -g root -m 644 -D -t $(systemddir) $(services)
	install -o root -g root -m 755 -D -t $(scriptdir) $(scripts)
	systemctl daemon-reload
	systemctl enable $(services)
	
check:
	systemd-analyze verify $(services)

uninstall:
	systemctl disable $(services)
	(cd $(systemddir) && rm -f $(services))
	(cd $(scriptdir) && rm -f $(scripts))
	([ -n "$(ls -A $(scriptdir)/)" ] || rmdir -p $(scriptdir))
	systemctl daemon-reload
