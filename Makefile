include theos/makefiles/common.mk

GO_EASY_ON_ME = 1

expert THEOS_DEVICE_IP=192.168.1.101

TWEAK_NAME = Slide2Kill7
Slide2Kill7_FILES = Tweak.xm
Slide2Kill7_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
