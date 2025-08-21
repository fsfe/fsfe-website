FROM debian:latest

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install deps
RUN apt-get update && apt-get install --yes --no-install-recommends \
rsync \
libxslt1.1 \
libxml2 \
git \
node-less \
openssh-client \
ca-certificates \
expect

# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv
# Set the workdir
WORKDIR /website-source

# Copy the pyproject and build deps
# Done in a seperate step for optimal docker caching
COPY ./pyproject.toml .
RUN uv sync --no-install-package fsfe_website_build

# Copy everything else
COPY . .

ENTRYPOINT [ "bash", "./entrypoint.sh" ]


