FROM debian:latest
# Install deps
RUN apt update
RUN apt install -y \
rsync \
libxslt1.1 \
libxml2 \
golang \
python3 \
python3-venv \
python3-pip \
git \
node-less \
openssh-client

# SSH Private keys
ARG KEY_PRIVATE
ARG KEY_PASSWORD

RUN if [ "$KEY_PRIVATE" != "none" ]; then echo "$KEY_PRIVATE" | openssl rsa -passin pass:$KEY_PASSWORD | ssh-add - ; echo "VAR LOADED"; else echo "NO VAR"; fi

# Setup venv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Copy the requirements
# Done in a seperate step for optimal docker caching
COPY ./requirements.txt /website-source/requirements.txt
RUN pip install -r /website-source/requirements.txt

# Copy everything else
COPY . /website-source/
WORKDIR /website-source

ENTRYPOINT [ "bash", "./entrypoint.sh" ]


