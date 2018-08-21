#!/bin/sh

REPO=${1}
DOCKER_USERNAME=${2}
DOCKER_PASSWORD=${3}
DOCKER_REGESTRY=${4}
declare -A ARCH_MAP
ARCH_MAP[x86_64]=x86_64
ARCH_MAP[armhf]=arm
ARCH_MAP[arm64]=arm64

docker run --rm --privileged multiarch/qemu-user-static:register --reset
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Building docker images"
for i in "${!ARCH_MAP[@]}"; do
  echo "################################################################################"
  echo "Building and pushing: ${REPO}-${ARCH_MAP[$i]}:latest "
  echo "################################################################################"
  docker build --build-arg arch=${i} -t ${REPO}-${ARCH_MAP[$i]}:latest .;
  docker push ${REPO}-${ARCH_MAP[$i]}:latest;
done;

MANIFESTS=""
for arch in "${ARCH_MAP[@]}"; do MANIFESTS="${MANIFESTS} ${REPO}-${arch}:latest"; done

echo "################################################################################"
echo "Building and pushing: ${REPO}-${ARCH_MAP[$i]}:latest "
echo "################################################################################"
docker manifest create ${REPO}:latest ${MANIFESTS};

for arch in "${ARCH_MAP[@]}"; do 
  docker manifest annotate --os linux --arch ${arch} ${REPO}:latest ${REPO}-${arch}:latest;
done;

docker manifest push ${REPO}:latest 
