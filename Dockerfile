FROM alpine:3.8 as builder
ARG VERSION=v1.48.0

RUN apk -U add dumb-init
RUN wget https://github.com/ncw/rclone/releases/download/$VERSION/rclone-$VERSION-linux-amd64.zip
RUN unzip rclone-$VERSION-linux-amd64.zip
RUN cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone

FROM gcr.io/distroless/base
COPY --from=builder /usr/bin/rclone /usr/bin/rclone
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/bin/rclone"]
