FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04

ARG OPENCV_VERSION=4.5.0

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    vim \
    wget \
    pkg-config \
    python-pip \
    python3-pip \
    python-numpy \
    libjpeg-dev \
    libjpeg8-dev \
    libpng-dev \
    libtiff5-dev \
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libatlas-base-dev \
    libx264-dev \
    gfortran \
    libc6-dev-i386 \
    libavresample-dev \
    libgphoto2-dev \
    libx32gcc-4.8-dev \
    libgstreamer-plugins-base1.0-dev \
    libdc1394-22-dev

RUN pip3 install --upgrade pip


WORKDIR /opt
RUN wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.tar.gz --no-check-certificate && tar -xf $OPENCV_VERSION.tar.gz && rm $OPENCV_VERSION.tar.gz && \
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz --no-check-certificate && tar -xf $OPENCV_VERSION.tar.gz && rm $OPENCV_VERSION.tar.gz


RUN mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_CUDA=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D CUDA_ARCH_BIN=11.1 \
    -D WITH_CUBLAS=1 \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-$OPENCV_VERSION/modules \
    -D HAVE_opencv_python3=ON \
    -D BUILD_EXAMPLES=OFF /opt/opencv-$OPENCV_VERSION && \
    make -j7 && \
    make install && \
    ldconfig && \
    rm -rf /opt/opencv*
