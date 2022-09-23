MPB_PACKAGES := $(wildcard $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/package/*/*.mk)
MPB_PACKAGES += $(wildcard $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/../plugins/package/*/*.mk)

# 2022.05.2 buildroot contains some packages that are defined here, causing conflicts - prefer using BR2 provided packages.
ifeq ($(shell expr "$(BR2_VERSION)" \>= "2022.02.5"),1)

MPB_LOCAL_PACKAGES_TO_IGNORE := fluidsynth lilv lv2 python-pillow serd sord sratom

# These depend on python2, ignore them.
MPB_LOCAL_PACKAGES_TO_IGNORE += lvtk lvtk-1

define remove-dep
	MPB_PACKAGES := $(filter-out $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/package/$1/$1.mk, $(MPB_PACKAGES))
endef
$(foreach pkg,$(MPB_LOCAL_PACKAGES_TO_IGNORE), $(eval $(call remove-dep,$(pkg))))
endif

include $(sort $(MPB_PACKAGES))
