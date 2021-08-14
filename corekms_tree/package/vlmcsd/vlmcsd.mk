################################################################################
#
# vlmcsd
#
################################################################################

VLMCSD_VERSION = svn1113
VLMCSD_SOURCE = svn1113.tar.gz
VLMCSD_SITE = https://github.com/Wind4/vlmcsd/archive/refs/tags
VLMCSD_DEPENDENCIES =
# VLMCSD_LICENSE =
# VLMCSD_LICENSE_FILES =

# Not sure if it works.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
CRYPTO = openssl
VLMCSD_DEPENDENCIES += openssl
endif

define VLMCSD_BUILD_CMDS
	# Just clean it: such a small project won't take long compiling.
	$(MAKE) -C $(@D) clean
	CFLAGS="$(TARGET_CFLAGS) -DNO_LOG -DNO_HELP -DNO_SIGHUP -DNO_INI_FILE -DNO_USER_SWITCH -DNO_CUSTOM_INTERVALS -DSIMPLE_SOCKETS -DNO_CL_PIDS -DNO_VERSION_INFORMATION -DNO_PID_FILE" $(MAKE) CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) vlmcsd
endef

define VLMCSD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/vlmcsd $(TARGET_DIR)/usr/bin
endef

define VLMCSD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(VLMCSD_PKGDIR)/S50vlmcsd $(TARGET_DIR)/etc/init.d/S50vlmcsd
endef

$(eval $(generic-package))
