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
node-less \
python3 \
python3-venv \
python3-pip

WORKDIR /fsfe-websites
ENTRYPOINT ["python3", "./build.py" ]


