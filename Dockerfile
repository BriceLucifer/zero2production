# Builder Stage
FROM rust AS builder

WORKDIR /app
RUN apt update && apt install lld clang -y
COPY . .
ENV SQLX_OFFLINE=true
RUN cargo build --release

# Runtime Stage
FROM rust AS runtime

WORKDIR /app
# COPY the compiler binary from the builder environment
# to our runtime environment
COPY --from=builder /app/target/release/zero2prod zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT=production
ENTRYPOINT [ "./target/release/zero2prod" ]
