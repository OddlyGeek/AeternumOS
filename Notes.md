


#Setup Nvidia
1. add hw.nvidiadrm.modeset=1 to /boot/loader.confq
2. To enable the driver, add the module to /etc/rc.conf file, by executing the following command: sysrc kld_list+=nvidia-drm