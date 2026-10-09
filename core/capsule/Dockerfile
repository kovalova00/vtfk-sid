FROM rust:latest AS build
WORKDIR /app

COPY core/sid/Cargo.toml core/sid/Cargo.lock ./

RUN mkdir -p src && echo 'fn main() {}' > src/main.rs
RUN cargo build --release

COPY core/sid/src ./src

RUN cargo build --release

FROM debian:12-slim
WORKDIR /app
COPY --from=build /app/target/release/vtfk-sid /app/vtfk-sid
CMD ["./vtfk-sid"]