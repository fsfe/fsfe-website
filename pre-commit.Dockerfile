FROM alpine:3.24

# Install deps
RUN apk add --no-cache \
composer \
git \
libxml2 \
libxml2-utils \
npm \
php84-zip \
python3 \
rsync \
shfmt \
uv

# Install node deps
# Alpine does not package lessc
RUN npm install -g prettier less
# Install php cs fixer
RUN composer global require friendsofphp/php-cs-fixer
# Add composer to path
ENV PATH="/root/.composer/vendor/bin:$PATH"
# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv
# Use the python3 from apk. Fail instead of downloading another one
ENV UV_PYTHON_DOWNLOADS=never
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
