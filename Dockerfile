FROM eventdrivenrobotics/event-driven:bionic_yarp_v3.3.2_ed_v1.5

ARG hvga=0

ENV DEBIAN_FRONTEND noninteractive 

RUN apt update

RUN apt install -y ca-certificates

RUN if [ $hvga -eq 1 ]; then \
		echo "Installing older 1.4 version for HVGA"; \
		echo "deb [arch=amd64 trusted=yes] https://prophesee:DbnLdKL5YXnMndWg@apt.prophesee.ai/dists/ubuntu bionic main" >> /etc/apt/sources.list; \
    apt update; \
    apt install -y prophesee-* \
    libboost-filesystem-dev \
    libboost-system-dev; \
	else \
    	echo "deb [arch=amd64 trusted=yes] https://prophesee:DbnLdKL5YXnMndWg@apt.prophesee.ai/dists/public/pyR7K4hz/ubuntu bionic essentials" >> /etc/apt/sources.list; \
      apt update; \
      apt install -y metavision-*; \
    fi

RUN apt install -y \
  libcanberra-gtk-module \
  libboost-chrono-dev \
  python3.7 \
  python3-pip \
  python3-tk \
  cmake \
  && apt-get autoremove \
  && apt-get clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN pip3 install \
  scikit-build 


RUN pip3 install \
#  opencv-python  \
  matplotlib \
  jupyter

RUN cd /usr/local/src/event-driven/build &&\
	git checkout atis3_bridge_for_hvga && git pull &&\
    cmake -DBUILD_HARDWAREIO=ON \
          -DENABLE_atis3=ON \
          -DVLIB_CLOCK_PERIOD_NS=1000 \
          .. &&\
    make -j `nproc` install
