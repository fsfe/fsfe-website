FROM debian:13

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install deps
RUN apt-get update && apt-get install --yes --no-install-recommends \
coreutils \
curl \
file \
findutils \
git \
grep \
libxml2 \
libxml2-utils \
libxslt1.1 \
mediainfo \
npm \
perl-base \
rsync \
sed \
shfmt

# Install prettier
RUN npm install -g prettier
# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv
# Add vent to path
ENV PATH="$UV_PROJECT_ENVIRONMENT/bin:$PATH"

# Set the workdir
WORKDIR /website-source-during-build

# Copy the pyproject and build deps
# Done in a seperate step for optimal docker caching
COPY ./pyproject.toml ./uv.lock .
RUN uv sync --no-install-package fsfe_website_build --group dev

# Copy entrypoint
COPY pre-commit.entrypoint.sh .

# Set the workdir
WORKDIR /website-source

ENTRYPOINT ["bash", "/website-source-during-build/pre-commit.entrypoint.sh"]


