FROM alpine:latest

WORKDIR /build

ENV CLONE_URL=https://bitbucket.org/multicoreware/x265 \
    CLONE_BRANCH=stable \
    MAIN_CLI=DISABLED \
    MAIN_LIB_STATIC=DISABLED \
    MAIN_LIB_SHARED=DISABLED \
    MAIN10_CLI=DISABLED \
    MAIN10_LIB_STATIC=DISABLED \
    MAIN10_LIB_SHARED=DISABLED \
    MAIN12_CLI=DISABLED \
    MAIN12_LIB_STATIC=DISABLED \
    MAIN12_LIB_SHARED=DISABLED \
    MULTI_LIB_STATIC=DISABLED

RUN mkdir /output && \
    apk --update add \
      build-base \
      cmake \
      mercurial \
      yasm
      
VOLUME /output
COPY ./build-x265.sh .
ENTRYPOINT ["./build-x265.sh"]