FROM debian:stable-slim

RUN apt update && apt upgrade -y && apt install wget git build-essential libmpc-dev zlib1g zlib1g-dev -y
RUN wget https://ftpmirror.gnu.org/binutils/binutils-2.30.tar.gz
RUN wget https://ftpmirror.gnu.org/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz
RUN wget https://ftpmirror.gnu.org/mpfr/mpfr-4.0.1.tar.gz 
RUN wget https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.bz2 
RUN wget https://ftpmirror.gnu.org/mpc/mpc-1.1.0.tar.gz 
RUN wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2 
RUN wget https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
RUN for i in *.tar.gz; do tar -xzf $i; done
RUN for i in *.tar.bz2; do tar -xjf $i; done
RUN rm -f *.tar.*
RUN cd binutils-* && \
ln -s ../isl-* isl
RUN cd gcc-* &&\
ln -s ../isl-* isl &&\
ln -s ../mpfr-* mpfr &&\
ln -s ../gmp-* gmp &&\
ln -s ../mpc-* mpc &&\
ln -s ../cloog-* cloog

RUN mkdir aarch64-binutils
RUN cd aarch64-binutils &&\
../binutils-*/configure --prefix=/usr/local/cross-compiler --target=aarch64-elf \
--enable-shared --enable-threads=posix --enable-libmpx --with-system-zlib --with-isl --enable-__cxa_atexit \
--disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-plugin \
--disable-linker-build-id --enable-lto --enable-install-libiberty --with-linker-hash-style=gnu --with-gnu-ld\
--enable-gnu-indirect-function --disable-multilib --disable-werror --enable-checking=release --enable-default-pie \
--enable-default-ssp --enable-gnu-unique-object && \
make -j `getconf _NPROCESSORS_ONLN` &&\
make install

RUN mkdir aarch64-gcc
RUN cd aarch64-gcc && \
../gcc-*/configure --prefix=/usr/local/cross-compiler --target=aarch64-elf --enable-languages=c \
--enable-shared --enable-threads=posix --enable-libmpx --with-system-zlib --with-isl --enable-__cxa_atexit \
--disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-plugin \
--disable-linker-build-id --enable-lto --enable-install-libiberty --with-linker-hash-style=gnu --with-gnu-ld\
--enable-gnu-indirect-function --disable-multilib --disable-werror --enable-checking=release --enable-default-pie \
--enable-default-ssp --enable-gnu-unique-object && \
make -j `getconf _NPROCESSORS_ONLN` all-gcc &&\
make install-gcc
ENV PATH=$PATH:/usr/local/cross-compiler/bin