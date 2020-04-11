export ARCHS := arm64
export TARGET := iphone:clang:13.0:11.0

include $(THEOS)/makefiles/common.mk

SAUCE = $(shell find Src -name '*.m')

TWEAK_NAME = EvilScheme
EvilScheme_FILES = src/EvilScheme.xm $(SAUCE)
EvilScheme_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload || killall -9 SpringBoard"

SUBPROJECTS += EvilKit
include $(THEOS_MAKE_PATH)/aggregate.mk
