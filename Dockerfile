FROM archlinux:latest

ENV TARGET=i686-elf
ENV PREFIX=/opt/cross
ENV PATH="$PREFIX/bin:$PATH"

RUN pacman -Sy --noconfirm base-devel gmp mpfr libmpc texinfo curl && \
    pacman -Scc --noconfirm

RUN mkdir -p /tmp/src && cd /tmp/src && \
    curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz && \
    tar -xf binutils-2.43.tar.xz && \
    mkdir binutils-build && cd binutils-build && \
    ../binutils-2.43/configure --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-werror && \
    make -j$(nproc) && \
    make install && \
    cd /tmp/src && rm -rf binutils-2.43 binutils-build

RUN cd /tmp/src && \
    curl -O https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz && \
    tar -xf gcc-14.2.0.tar.xz && \
    mkdir gcc-build && cd gcc-build && \
    ../gcc-14.2.0/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c --without-headers && \
    make all-gcc -j$(nproc) && \
    make all-target-libgcc -j$(nproc) && \
    make install-gcc && \
    make install-target-libgcc && \
    cd /tmp/src && rm -rf gcc-14.2.0 gcc-build

WORKDIR /workdir

CMD ["/bin/bash"]

