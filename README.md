# cris_navigation #

How to use:

1) Install Docker https://docs.docker.com/engine/install/
2) Install NVIDIA Container Toolkit https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
3) xhost + 
4) git clone -b ros1 https://github.com/zhichaoliu0921/cris_navigation.git
5) cd cris_navigation
6) docker build -t cris_navigation .
7)  sudo ./run_image.bash 
8) roslaunch cris_navigation move_base.launch
