FROM debian:13

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install deps
RUN apt-get update && apt-get install --yes --no-install-recommends \
ca-certificates \
expect \
git \
libxml2 \
libxslt1.1 \
node-less \
openssh-client \
rsync

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

ENTRYPOINT ["bash", "/website-source-during-build/build.entrypoint.sh"]


