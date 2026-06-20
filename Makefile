TARGET := iphone:clang:latest:15.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MostashTweak

MostashTweak_FILES = Tweak.xm \
    Core/SettingsManager.m \
    UI/FloatingButton.m \
    UI/ControlPanel.m

MostashTweak_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
