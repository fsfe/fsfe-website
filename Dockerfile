FROM ghcr.io/astral-sh/uv:debian-slim
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
golang-go \
node-less

WORKDIR /fsfe-websites
# Run using uv directly, as the shebang gets confused
ENTRYPOINT [ "uv", "run", "./build.py" ]


