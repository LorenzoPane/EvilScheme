export ARCHS := arm64 arm64e
export TARGET := iphone:clang:13.0:11.0

include $(THEOS)/makefiles/common.mk

SAUCE = $(shell find src -name '*.m')
HEADERS = $(shell find src -name '*.h')

FRAMEWORK_NAME = EvilKit
EvilKit_FILES = $(SAUCE)
EvilKit_PUBLIC_HEADERS = $(HEADERS)
EvilKit_INSTALL_PATH = /Library/Frameworks
EvilKit_PRIVATE_FRAMEWORKS = GeoServices
EvilKit_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/framework.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
