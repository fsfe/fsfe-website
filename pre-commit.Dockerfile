FROM alpine

# Install deps
RUN apk add --no-cache \
bash \
composer \
curl \
file \
git \
libxml2 \
libxml2-utils \
libxslt \
mediainfo \
minify \
npm \
perl \
php84-zip \
rsync \
shfmt \
uv 

# Install node deps
RUN npm install -g prettier less
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

RUN uv sync --no-install-package fsfe_website_build --group dev

# Set the workdir
WORKDIR /website-source

ENTRYPOINT ["/website-source-during-build/pre-commit.entrypoint.sh"]
