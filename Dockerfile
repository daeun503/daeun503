FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNNER_VERSION=2.329.0
ENV VENV_PATH=/opt/venv

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git unzip tar gzip  \
    ffmpeg \
    yt-dlp \
    python3 python3-venv python3-pip \
  && rm -rf /var/lib/apt/lists/*

# python deps (venv install)
RUN python3 -m venv ${VENV_PATH} \
  && ${VENV_PATH}/bin/python -m pip install --upgrade pip \
  && ${VENV_PATH}/bin/pip install --no-cache-dir feedparser requests colorthief

# runner user
RUN useradd -m -s /bin/bash runner

WORKDIR /home/runner
RUN curl -fsSL -o actions-runner.tar.gz \
      "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" \
  && tar xzf actions-runner.tar.gz \
  && rm -f actions-runner.tar.gz \
  && ./bin/installdependencies.sh \
  && chown -R runner:runner /home/runner

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner
ENV RUNNER_WORKDIR=_work

ENTRYPOINT ["/entrypoint.sh"]
