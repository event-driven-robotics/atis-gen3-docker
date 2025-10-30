ARG EVENT_DRIVEN_IMAGE=eventdrivenrobotics/event-driven:focal_yarp_v3.8.1_ed_vmain

#eventdrivenrobotics/event-driven:bionic_yarp_v3.3.2_ed_v1.5 3.1

FROM ${EVENT_DRIVEN_IMAGE}

ARG SDK_VERSION

ENV DEBIAN_FRONTEND noninteractive 

# Check SDK version and install appropriate packages  

RUN if [ $SDK_VERSION = "1.4" ]; then \
		echo "Installing older 1.4 version for HVGA"; \
		echo "deb [arch=amd64 trusted=yes] https://prophesee:DbnLdKL5YXnMndWg@apt.prophesee.ai/dists/ubuntu bionic main" >> /etc/apt/sources.list; \
    apt update; \
    apt install -y prophesee-* ; \
	elif [ $SDK_VERSION = "3.1" ]; then \
      echo "Installing version metavision SDK version 3.1"; \
    	wget -O  /etc/apt/sources.list.d/metavision.list https://files.prophesee.ai/share/dists/public/sources_list/wohr2Cho/focal/metavision.list; \
      apt update; \
      apt install -y metavision-sdk; \
  else \
      echo "SDK version ${SDK_VERSION} is not a valid option. Please set SDK_VERSION to 1.4 or 3.1"; \
      exit 1; \
    fi

WORKDIR /usr/local/src/event-driven/build

RUN cmake .. && make -j $(nproc) install