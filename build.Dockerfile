FROM alpine:3.24

# Install deps
RUN apk add --no-cache \
bash \
expect \
git \
minify \
npm \
openssh-client \
python3 \
rsync \
uv

# Install node deps
# Alpine does not package lessc
RUN npm install -g less

# Set uv project env, to persist stuff moving dirs 
ENV UV_PROJECT_ENVIRONMENT=/root/.cache/uv/venv
# Use the python3 from apk. Fail instead of downloading another one
ENV UV_PYTHON_DOWNLOADS=never

# Set the workdir
WORKDIR /website-source-during-build

# Copy the pyproject and build deps
# Done in a seperate step for optimal docker caching
COPY ./pyproject.toml ./uv.lock ./
COPY ./packages/build/pyproject.toml ./packages/build/
COPY ./packages/hooks/pyproject.toml ./packages/hooks/
RUN uv sync --package fsfe-website-build --no-install-workspace

# Copy entrypoint
COPY build.entrypoint.sh ./

# Set the workdir
WORKDIR /website-source

ENTRYPOINT ["/website-source-during-build/build.entrypoint.sh"]
