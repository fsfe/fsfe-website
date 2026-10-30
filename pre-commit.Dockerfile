FROM debian:13

COPY --from=ghcr.io/astral-sh/uv /uv /uvx /bin/

# Install deps
RUN apt-get update && apt-get install --yes --no-install-recommends \
composer \
git \
libxml2 \
libxml2-utils \
node-less \
npm \
php-zip \
rsync \
shfmt

# Install prettier
RUN npm install -g prettier
# Install php cs fixer
RUN composer global require friendsofphp/php-cs-fixer
# Add composer to path
ENV PATH="/root/.composer/vendor/bin:$PATH"
# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv
# Add vent to path
ENV PATH="$UV_PROJECT_ENVIRONMENT/bin:$PATH"

# Set the workdir
WORKDIR /website-source-during-build

# Copy pyproject, build deps & entrypoint
COPY ./pyproject.toml ./uv.lock pre-commit.entrypoint.sh ./
COPY ./packages/build/pyproject.toml ./packages/build/
COPY ./packages/hooks/pyproject.toml ./packages/hooks/

RUN uv sync --no-install-workspace --all-groups

# Set the workdir
WORKDIR /website-source

ENTRYPOINT ["/website-source-during-build/pre-commit.entrypoint.sh"]
