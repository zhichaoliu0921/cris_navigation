ARG ROS_DISTRO=noetic

FROM osrf/ros:$ROS_DISTRO-desktop-full

SHELL ["/bin/bash", "-c"]

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


RUN sudo apt update && apt install python3-rosdep git-all -y



WORKDIR /ros_ws

COPY . src/cris_navigation

# clone robot github repositories
RUN git clone https://github.com/husarion/rosbot_ros.git --branch=noetic src/rosbot_ros && \
    git clone https://github.com/husarion/rosbot_ekf.git --branch=master src/rosbot_ekf && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y


# build ROS workspace
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
	catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release


RUN apt update && apt install -y \
		python3-pip \
		ros-$ROS_DISTRO-rosserial-python \ 
		ros-$ROS_DISTRO-rosserial-server \
		ros-$ROS_DISTRO-rosserial-client \
		ros-$ROS_DISTRO-rosserial-msgs \
		ros-$ROS_DISTRO-move-base-msgs \
		ros-$ROS_DISTRO-robot-localization \
		ros-$ROS_DISTRO-xacro \
		ros-$ROS_DISTRO-transmission-interface \
		ros-$ROS_DISTRO-controller-manager \
		ros-$ROS_DISTRO-robot-state-publisher && \
	pip3 install python-periphery && \
	pip3 install sh && \
	pip3 install pyserial && \
	python3 -m pip install --upgrade pyserial


RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc && \
	echo ". /ros_ws/devel/setup.bash" >> ~/.bashrc && \
	# allows us to run: docker exec -it rosbot bash --login -c "rostopic list"
	echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.profile && \
	echo ". /ros_ws/devel/setup.bash" >> ~/.profile

WORKDIR /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
