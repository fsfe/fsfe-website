FROM alpine

# Install deps
RUN apk add --no-cache \
bash \
expect \
git \
libxml2 \
libxslt \
npm \
openssh-client \
rsync \
uv

# Install node deps
RUN npm install -g less

# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv

# Set the workdir
WORKDIR /website-source-during-build

# Copy the pyproject and build deps
# Done in a seperate step for optimal docker caching
COPY ./pyproject.toml ./uv.lock ./
RUN uv sync --no-install-package fsfe_website_build

# Copy entrypoint
COPY build.entrypoint.sh ./

# Set the workdir
WORKDIR /website-source

ENTRYPOINT ["/website-source-during-build/build.entrypoint.sh"]
