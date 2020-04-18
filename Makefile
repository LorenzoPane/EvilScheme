export ARCHS := arm64
export TARGET := iphone:clang:13.0:13.0

include $(THEOS)/makefiles/common.mk

SAUCE = $(shell find src -name '*.m' -maxdepth 1)

TWEAK_NAME = EvilScheme
EvilScheme_FILES = src/EvilScheme.xm $(SAUCE)
EvilScheme_CFLAGS = -fobjc-arc
EvilScheme_PRIVATE_FRAMEWORKS = UserActivity
EvilScheme_EXTRA_FRAMEWORKS += EvilKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload || killall -9 SpringBoard"

SUBPROJECTS += EvilKit
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
