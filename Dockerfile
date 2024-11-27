FROM debian:bookworm-slim
RUN apt update
# Install required packages
RUN apt install --yes \
bash \
coreutils \
rsync \
xsltproc \
libxml2-utils \
sed \
findutils \
grep \
make \
libc-bin \
wget \
procps \
python3 \
python3-bs4

WORKDIR /fsfe-websites
ENTRYPOINT ["bash", "./build.sh" ]


