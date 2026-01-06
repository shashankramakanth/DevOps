FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

#Install OCI
RUN pip install --no-cache-dir --user oci-cli

FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    vim \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/.local /root/.local

ENV PATH="/root/.local/bin:${PATH}"

RUN mkdir -p /root/.oci /root/.ssh /workspace

WORKDIR /workspace

RUN oci --version

CMD ["/bin/bash"]