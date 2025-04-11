# Use a base image with the necessary build tools
FROM debian:bullseye-slim

# Install required dependencies for Buildroot
RUN apt-get update && apt-get install -y \
  bc \
  bison \
  flex \
  gawk \
  gcc \
  build-essential \
  make \
  ncurses-dev \
  pkg-config \
  libcrypt-dev \
  perl \
  unzip \
  wget \
  cpio \
  file \
  rsync \
  python3 \
  patch \
  git \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container

RUN git clone https://github.com/buildroot/buildroot.git -b 2025.02.x /buildroot

RUN useradd -ms /bin/bash user
USER user

WORKDIR /home/user

# Optionally, copy the Buildroot source code into the container (or use a volume to mount it)
# COPY buildroot /buildroot

# Optionally, copy a custom defconfig into the container (or mount it as a volume)
# COPY my_defconfig .config

# Set environment variables (can also be done when running the container)

# Optional: Use tmpfs for the build output directory
# When running the container, we'll mount the tmpfs directory to /tmp/buildroot-output

# Default command to show Buildroot is ready
CMD ["bash"]
