.DEFAULT_GOAL := all
RELEASES := 	kinetic \
		melodic \
		noetic

.PHONY: all

lego-loam-%: lego-loam.Dockerfile
	docker build -t "pszenher/lego-loam:$*" -f "lego-loam.Dockerfile" --build-arg="ROS_DISTRO=$*" ..

all: $(addprefix lego-loam-,$(RELEASES))
