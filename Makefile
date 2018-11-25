include $(THEOS)/makefiles/common.mk
TWEAK_NAME = colorfulwidgets
colorfulwidgets_FILES = $(wildcard *.xm *.m)
ARCHS=arm64
include $(THEOS_MAKE_PATH)/tweak.mk
colorfulwidgets_LIBRARIES = colorpicker

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += colorfulwidgetsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
