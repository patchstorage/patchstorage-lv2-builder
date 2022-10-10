MPB_PACKAGES := $(wildcard $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/package/*/*.mk)
MPB_PACKAGES += $(wildcard $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/../plugins/package/*/*.mk)

# 2021.11.3 buildroot contains some packages that are defined here, causing conflicts - prefer using BR2 provided packages.
ifeq ($(shell expr "$(BR2_VERSION)" \>= "2021.11.3"),1)

MPB_LOCAL_PACKAGES_TO_IGNORE := fluidsynth python-pillow # These are available in 2022.02.5: lilv lv2 serd sord sratom

define remove-dep
	MPB_PACKAGES := $(filter-out $(BR2_EXTERNAL_MOD_PLUGIN_BUILDER_PATH)/package/$1/$1.mk, $(MPB_PACKAGES))
endef
$(foreach pkg,$(MPB_LOCAL_PACKAGES_TO_IGNORE), $(eval $(call remove-dep,$(pkg))))
endif

include $(sort $(MPB_PACKAGES))
