FROM fedora:latest

# Install required packages
RUN dnf install -y \
rsync \
libxslt \
libxml2 \
golang \
python3 \
python3-pip \
git \
nodejs-less \
openssh-clients

# SSH Private keys
ARG KEY_PRIVATE
ARG KEY_PASSWORD

RUN if [ "$KEY_PRIVATE" != "none" ]; then echo "$KEY_PRIVATE" | openssl rsa -passin pass:$KEY_PASSWORD | ssh-add - ; echo "VAR LOADED"; else echo "NO VAR"; fi


# Copy the requirements
# Done in a seperate step for optimal docker caching
COPY ./requirements.txt /website-source/requirements.txt
RUN pip install -r /website-source/requirements.txt --root-user-action=ignore

# Copy everything else
COPY . /website-source/
WORKDIR /website-source

ENTRYPOINT [ "bash", "./entrypoint.sh" ]


