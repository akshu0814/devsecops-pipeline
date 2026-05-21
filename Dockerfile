# ── Stage 1: builder ──────────────────────────────────────────────────────────
# We install dependencies here. This stage has pip and build tools,
# which we don't want in the final image (larger attack surface).
FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt


# ── Stage 2: runtime ──────────────────────────────────────────────────────────
# We copy only the installed packages and app code from the builder stage.
# The final image has no pip, no build tools — smaller and more secure.
FROM python:3.12-slim AS runtime

# Create a non-root user. Running as root inside a container is a security risk:
# if the process is compromised, the attacker has root access to the container.
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy application source
COPY app/ ./app/

# Switch to non-root user before the final CMD
USER appuser

EXPOSE 5000

CMD ["python", "-m", "flask", "--app", "app.main", "run", "--host=0.0.0.0", "--port=5000"]
