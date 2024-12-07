# Makefile for OpenWrt package rtp2httpd

include $(TOPDIR)/rules.mk

PKG_NAME:=rtp2httpd
PKG_VERSION:=$(shell date +%Y%m%d)
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/stackia/rtp2httpd
PKG_SOURCE_VERSION:=master

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/rtp2httpd
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Multicast RTP to Unicast HTTP stream converter with FCC support
	URL:=https://github.com/stackia/rtp2httpd
endef

define Package/rtp2httpd/description
	Multicast RTP to Unicast HTTP stream converter with FCC support.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(SED) 's,/usr/local,$(STAGING_DIR)/usr,g' $(PKG_BUILD_DIR)/Makefile.am
	$(SED) 's,/usr/local,$(STAGING_DIR)/usr,g' $(PKG_BUILD_DIR)/configure.ac
endef

define Build/Configure
	(cd $(PKG_BUILD_DIR); autoreconf -i)
	$(call Build/Configure/Default)
endef

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/rtp2httpd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/rtp2httpd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/rtp2httpd $(1)/etc/init.d/rtp2httpd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/rtp2httpd $(1)/etc/config/rtp2httpd
endef

$(eval $(call BuildPackage,rtp2httpd))