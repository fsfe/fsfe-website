FROM fedora:latest
# Install required packages
RUN dnf install -y \
rsync \
libxslt \
libxml2 \
golang \
python3 \
python3-pip \
nodejs-less

# Copy the local repo
COPY . /website-source/
RUN pip install -r /website-source/requirements.txt --root-user-action=ignore

WORKDIR /website-source

ENTRYPOINT [ "bash", "./entrypoint.sh" ]
CMD [ "--target", "/website-cached/result" ]


