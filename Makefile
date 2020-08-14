export ARCHS := arm64 arm64e
export TARGET := iphone:clang:13.0:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EvilScheme
EvilScheme_FILES = EvilScheme.x
EvilScheme_CFLAGS = -fobjc-arc
EvilScheme_PRIVATE_FRAMEWORKS = UserActivity CoreServices
EvilScheme_EXTRA_FRAMEWORKS += EvilKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload || killall -9 SpringBoard"

SUBPROJECTS += EvilKit
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
