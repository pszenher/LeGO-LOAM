ARG ROS_DISTRO=kinetic
FROM ros:${ROS_DISTRO}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /catkin_ws/{src,deps} && \
    git clone --branch "4.0.3" --depth=1 "https://github.com/borglab/gtsam" "/catkin_ws/deps/gtsam"

RUN apt-get update && rosdep install -iy --from-paths "/catkin_ws/deps" && \
    cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_USE_SYSTEM_EIGEN=ON "/catkin_ws/deps/gtsam" -B"/catkin_ws/deps/gtsam/build" && \
    make -j"$(nproc)" -C "/catkin_ws/deps/gtsam/build" install

COPY ./package.xml /catkin_ws/src/lego-loam/package.xml

RUN apt-get update && \
    rosdep install -iy --from-paths "/catkin_ws/src" \
    && rm -rf /var/lib/apt/lists/*

COPY . /catkin_ws/src/lego-loam

RUN /ros_entrypoint.sh catkin_make -j"$(nproc)" --directory /catkin_ws -DCMAKE_INSTALL_PREFIX="/opt/ros/${ROS_DISTRO}" install

ENTRYPOINT [ "/ros_entrypoint.sh" ]
