######################################
#
# screcord
#
######################################

SCRECORD_VERSION = 7025a7e52a639872fde79d46afce38ece4639d20
SCRECORD_SITE = $(call github,BlokasLabs,screcord.lv2,$(SCRECORD_VERSION))
SCRECORD_BUNDLES = sc_record.lv2

ifdef BR2_cortex_a7
SCRECORD_SSE_CFLAGS = -mfpu=vfpv3
else
SCRECORD_SSE_CFLAGS = ""
endif

SCRECORD_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE)  SSE_CFLAGS="$(SCRECORD_SSE_CFLAGS)" -C $(@D)

define SCRECORD_BUILD_CMDS
	$(SCRECORD_TARGET_MAKE) mod
endef

define SCRECORD_INSTALL_TARGET_CMDS
	$(SCRECORD_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
endef

$(eval $(generic-package))
