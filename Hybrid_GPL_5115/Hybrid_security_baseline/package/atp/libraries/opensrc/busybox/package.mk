#############################################################
#
# busybox
#
#############################################################

#
# Dependencies
#
BUSYBOX_DEPENDENCIES = atptypes zlib ssl gplutil

#############################################################
### Version and change logs area
BUSYBOX_VERSION = V1.01
define BUSYBOX_CHANGELOGS
V1.01:
	1. First release by Handy.
endef
#############################################################

BUSYBOX_TAR_SRC = $(TOPDIR)/dl/busybox-1.9.1.tar.gz
BUSYBOX_AFTER_EXTR_SRC = $(O)/build/busybox-1.9.1
BUSYBOX_TAR_EXTRACT_OPT = tar zxvf

SERVICE_BUSYBOX_SRC_DIR = $(BUSYBOX_AFTER_EXTR_SRC)/src

BUSYBOX_BUILD_CONFIG = $(SERVICE_BUSYBOX_SRC_DIR)/.config

# License
BUSYBOX_LICENSE = GPL

# Target name
BUSYBOX_TARGET = install

define BUSYBOX_INSTALL_HEADER_CMDS
	$(Q)if [ -d $($(2)_AFTER_EXTR_SRC) ]; then \
	echo "not need extract!";\
	else \
	$(call ATPMESSAGE,$(2),"Extracting $$(1)"); \
	mkdir -p $($(2)_AFTER_EXTR_SRC); \
	cd $($(2)_AFTER_EXTR_SRC); \
	$($(2)_TAR_EXTRACT_OPT) $($(2)_TAR_SRC); \
	fi
	$(Q)chmod -R 777 $(SERVICE_BUSYBOX_SRC_DIR)
endef

define BUSYBOX_BUILD_CMDS
	$(Q)if [ -f $(SERVICE_BUSYBOX_SRC_DIR)/Makefile ]; then \
	$(TARGET_ATP_ENVS) O=$$($(2)_BDIR)/ PROGRAM_NAME=$$($(2)_REAL_PROGRAM_NAME) IS_DYNAMIC="$$($(2)_IS_DYNAMIC)" CMSLIBS="$$(CMSTARGETS_LIBS)" WEBLIBS="$$(WEBTARGETS_LIBS)" CLILIBS="$$(CLITARGETS_LIBS)" ATPFLAGS="-DMODULE_VERSION=\\\"$$($(2)_VERSION_STR)\\\" -D$(2)_MODULE_VERSION=\\\"$$($(2)_VERSION_STR)\\\" $$($(2)_FLAGS)" $(MAKE1) -C $(SERVICE_BUSYBOX_SRC_DIR) $$($(2)_TARGET); \
	fi
endef

define BUSYBOX_CLEAN_CMDS
	$(Q)if [ -f $(SERVICE_BUSYBOX_SRC_DIR)/Makefile ]; then \
	$(CLEAN_ATP_ENVS) O=$$($(2)_BDIR)/ PROGRAM_NAME=$$($(2)_REAL_PROGRAM_NAME) $(MAKE1) -C $(SERVICE_BUSYBOX_SRC_DIR) clean; \
	fi
endef

define BUSYBOX_INSTALL_TARGET_CMDS
	$(Q)if [ -f $(SERVICE_BUSYBOX_SRC_DIR)/Makefile ]; then \
	install -m 777 $(SERVICE_BUSYBOX_SRC_DIR)/$$($(2)_FULL_PROGRAM_NAME) $(STAGING_DIR)/bin; \
	install -m 777 $(SERVICE_BUSYBOX_SRC_DIR)/$$($(2)_FULL_PROGRAM_NAME) $(TARGET_DIR)/bin; \
	$(TARGET_STRIP) $(STAGING_DIR)/bin/$$($(2)_FULL_PROGRAM_NAME); \
	$(TARGET_STRIP) $(TARGET_DIR)/bin/$$($(2)_FULL_PROGRAM_NAME); \
	echo ""; \
	else \
	echo $(error) $(O)/$$($(2)_BDIR)/$$($(2)_FULL_PROGRAM_NAME) not exist! exit 1; \
	fi
endef

#***************************************************************************
#	Set Busybox .config
#	arg1: BUILD_XXX
#	arg2: CONFIG_XXX
#***************************************************************************
define BUSYBOX_SET_KCONFIG
	$(if $(1),$(call ATP_KCONFIG_ENABLE_OPT,$(2),$(BUSYBOX_BUILD_CONFIG)), \
		$(call ATP_KCONFIG_DISABLE_OPT,$(2),$(BUSYBOX_BUILD_CONFIG));)
endef

define BUSYBOX_SET_MV
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_MV),CONFIG_MV)
endef

define BUSYBOX_SET_TFTP
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_TFTP),CONFIG_ATP_TFTP)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_TFTP),CONFIG_FEATURE_ATP_TFTP_GET)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_TFTP),CONFIG_FEATURE_ATP_TFTP_PUT)
endef

define BUSYBOX_SET_IPV6
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_FEATURE_IPV6),CONFIG_FEATURE_IPV6)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_PING6),CONFIG_ATP_PING6)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_TRACEROUTE6),CONFIG_ATP_TRACEROUTE6)
endef

define BUSYBOX_SET_IFENSLAVE
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_IFENSLAVE),CONFIG_ATP_IFENSLAVE)
endef

define BUSYBOX_SET_ATP_FTPD
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_TFTPD),CONFIG_TFTPD)
endef

define BUSYBOX_SET_ATP_FTP
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_FTP),CONFIG_ATP_FTP)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_FTP),CONFIG_ATP_FTPGET)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_FTP),CONFIG_ATP_FTPPUT)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_FTP_ZIP),CONFIG_FEATURE_ATP_FTP_ZIP)
endef

define BUSYBOX_SET_ATP_WGET
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_WGET),CONFIG_ATP_WGET)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_WGET),CONFIG_FEATURE_ATP_WGET_AUTHENTICATION)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_WGET_HTTPS),CONFIG_FEATURE_ATP_WGET_HTTPS)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_ATP_WGET_ZIP),CONFIG_FEATURE_ATP_WGET_ZIP)
endef

define BUSYBOX_SET_SLEEP
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_SLEEP),CONFIG_SLEEP)
endef

define BUSYBOX_SET_SU
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_SU),CONFIG_SU)
endef

define BUSYBOX_SET_CROND
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_CRONTAB),CONFIG_CROND)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_CRONTAB),CONFIG_CRONTAB)
endef

define BUSYBOX_SET_DIFF
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_DIFF),CONFIG_DIFF)
endef

define BUSYBOX_SET_SED
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_SED),CONFIG_SED)
endef

define BUSYBOX_SET_AWK
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_AWK),CONFIG_AWK)
endef

define BUSYBOX_SET_GETOPT_LONG
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_GETOPT_LONG),CONFIG_GETOPT_LONG)
endef

define BUSYBOX_SET_START_STOP_DAEMON
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_START_STOP_DAEMON),CONFIG_START_STOP_DAEMON)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_START_STOP_DAEMON_FANCY),CONFIG_FEATURE_START_STOP_DAEMON_FANCY)
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_START_STOP_DAEMON_LONG_OPTIONS),CONFIG_FEATURE_START_STOP_DAEMON_LONG_OPTIONS)	
endef

define BUSYBOX_SET_TRUE
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_TRUE),CONFIG_TRUE)
endef

define BUSYBOX_SET_CUT
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_CUT),CONFIG_CUT)
endef

define BUSYBOX_SET_GREP
	$(call BUSYBOX_SET_KCONFIG,$(BUILD_BUSYBOX_GREP),CONFIG_GREP)
endef


define BUSYBOX_CONFIGURE_CMDS
	$(Q)if [ -d $($(2)_AFTER_EXTR_SRC) ]; then \
	echo "not need extract!";\
	else \
	$(call ATPMESSAGE,$(2),"Extracting $$(1)"); \
	mkdir -p $($(2)_AFTER_EXTR_SRC); \
	cd $($(2)_AFTER_EXTR_SRC); \
	$($(2)_TAR_EXTRACT_OPT) $($(2)_TAR_SRC); \
	fi
	@echo "" >$(BUSYBOX_BUILD_CONFIG).verify;
	$(Q)cp -f $$(BUSYBOX_DIR)/defconfig $(BUSYBOX_BUILD_CONFIG)
	$(BUSYBOX_SET_GETOPT_LONG)	
	$(BUSYBOX_SET_ATP_FTP)
	$(BUSYBOX_SET_ATP_FTPD)
	$(BUSYBOX_SET_TFTP)
	$(BUSYBOX_SET_MV)
	$(BUSYBOX_SET_IPV6)
	$(BUSYBOX_SET_ATP_WGET)
	$(BUSYBOX_SET_SLEEP)
	$(BUSYBOX_SET_SU)
	$(BUSYBOX_SET_CROND)
	$(BUSYBOX_SET_DIFF)
	$(BUSYBOX_SET_SED)
	$(BUSYBOX_SET_AWK)
	$(BUSYBOX_SET_START_STOP_DAEMON)
	$(BUSYBOX_SET_TRUE)
	$(BUSYBOX_SET_CUT)
	$(BUSYBOX_SET_GREP)
	$(BUSYBOX_SET_IFENSLAVE)
#/* <DTS2013020703621 q00186737 2013/02/07 begin*/
ifeq ($(PRODUCT),b880)
	install -m 777 $$(BUSYBOX_DIR)/device_table_b880.dynamic $(DEVICETABLE_DIR)
#/* <DTS2013092310511 z00182709 2013/09/24 begin */
else ifeq ($(PRODUCT),b881)
	install -m 777 $$(BUSYBOX_DIR)/device_table_b881.dynamic $(DEVICETABLE_DIR)
#/* DTS2013092310511 z00182709 2013/09/24 end> */
else
	install -m 777 $$(BUSYBOX_DIR)/device_table_default.dynamic $(DEVICETABLE_DIR)
endif
#/* DTS2013020703621 q00186737 2013/02/07 end> */
endef

define BUSYBOX_BRANCH_BINARY_CMDS
	echo ""
endef

$(eval $(call ATPTARGETS,package/atp/libraries/opensrc/busybox,busybox))