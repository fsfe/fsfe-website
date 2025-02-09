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
ARG SSH_KEY_1
ARG SSH_KEY_2
ARG SSH_KEY_3
ARG SSH_KEY_4

RUN if [ "$SSH_KEY_1" != "none" ]; then ssh-agent sh -c 'ssh-add - < "${SSH_KEY_1}"'; echo "VAR LOADED"; else echo "NO VAR"; fi
RUN if [ "$SSH_KEY_2" != "none" ]; then ssh-agent sh -c 'ssh-add - < "${SSH_KEY_2}"'; echo "VAR LOADED"; else echo "NO VAR"; fi
RUN if [ "$SSH_KEY_3" != "none" ]; then ssh-agent sh -c 'ssh-add - < "${SSH_KEY_3}"'; echo "VAR LOADED"; else echo "NO VAR"; fi
RUN if [ "$SSH_KEY_4" != "none" ]; then ssh-agent sh -c 'ssh-add - < "${SSH_KEY_4}"'; echo "VAR LOADED"; else echo "NO VAR"; fi


# Copy the local repo
COPY . /website-source/
RUN pip install -r /website-source/requirements.txt --root-user-action=ignore

WORKDIR /website-source

ENTRYPOINT [ "bash", "./entrypoint.sh" ]
CMD [ "--target", "/website-cached/result" ]


