FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y python3 pkg-config curl git build-essential libssl-dev
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain nightly -y
ENV PATH="$PATH:/root/.cargo/bin"

# Build rustc_codegen_cranelift
RUN git clone --depth=1 https://github.com/bjorn3/rustc_codegen_cranelift
RUN cd rustc_codegen_cranelift && ./y.rs prepare && ./y.rs build
ENV CRANELIFT_DIR="/rustc_codegen_cranelift"

# Build miri
RUN git clone --depth=1 https://github.com/rust-lang/miri.git
RUN cargo install rustup-toolchain-install-master
RUN cd miri && ./miri toolchain && ./miri build --release
ENV MIRI_DIR="/miri"
