deps_config := \
	/home/sgf/ws/k230_pangofly//Kconfig.secureboot \
	/home/sgf/ws/k230_pangofly//Kconfig.fastboot \
	/home/sgf/ws/k230_pangofly//src/applications/helloworld/Kconfig \
	/home/sgf/ws/k230_pangofly//output/k230_rtos_lckfb_defconfig/Kconfig.app \
	/home/sgf/ws/k230_pangofly//src/applications/Kconfig \
	/home/sgf/ws/k230_pangofly//src/canmv/Kconfig.openmv \
	/home/sgf/ws/k230_pangofly//src/canmv/Kconfig.micropython \
	/home/sgf/ws/k230_pangofly//output/k230_rtos_lckfb_defconfig/Kconfig.canmv \
	/home/sgf/ws/k230_pangofly//src/opensbi/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/mpp/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/examples/integrated_poc/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/examples/ai/ai_demo/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/examples/ai/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/examples/mpp/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/examples/3rd-party/Kconfig \
	/home/sgf/ws/k230_pangofly//output/k230_rtos_lckfb_defconfig/Kconfig.rtt_examples \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/rtsmart_hal/utils/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/rtsmart_hal/components/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/rtsmart_hal/drivers/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/rtsmart_hal/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/3rd-party/mqttclient/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/3rd-party/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/libs/Kconfig \
	/home/sgf/ws/k230_pangofly//src/rtsmart/Kconfig \
	/home/sgf/ws/k230_pangofly//src/uboot/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_canmv_lushanpi_lite/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_mrt/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_labplus_1956/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_labplus_ai_camera_v2/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_labplus_ai_camera/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_evb/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_canmv_atk_dnk230d/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_aihardware/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_rtt_evb/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_dongshanpi/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_canmv_mini/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_canmv_junroc_ai_cam/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230d_canmv_bpi_zero/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_gt6700/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_wondermk/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_hiwonder/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_01studio/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_lckfb/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv_v3p0/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/k230_canmv/Kconfig \
	/home/sgf/ws/k230_pangofly//boards/Kconfig.memory_static \
	/home/sgf/ws/k230_pangofly//boards/Kconfig.memory_auto \
	/home/sgf/ws/k230_pangofly//boards/Kconfig \
	/home/sgf/ws/k230_pangofly//Kconfig \

include/config/auto.conf: $(deps_config)

ifneq "$(SDK_BOARDS_DIR)" "/home/sgf/ws/k230_pangofly//boards"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_UBOOT_SRC_DIR)" "/home/sgf/ws/k230_pangofly//src/uboot"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_RTSMART_SRC_DIR)" "/home/sgf/ws/k230_pangofly//src/rtsmart"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_BUILD_DIR)" "/home/sgf/ws/k230_pangofly//output/k230_rtos_lckfb_defconfig"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_OPENSBI_SRC_DIR)" "/home/sgf/ws/k230_pangofly//src/opensbi"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_CANMV_SRC_DIR)" "/home/sgf/ws/k230_pangofly//src/canmv"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_APPS_SRC_DIR)" "/home/sgf/ws/k230_pangofly//src/applications"
include/config/auto.conf: FORCE
endif
ifneq "$(SDK_SRC_ROOT_DIR)" "/home/sgf/ws/k230_pangofly/"
include/config/auto.conf: FORCE
endif

$(deps_config): ;
