# syntax=docker/dockerfile:1

FROM alpine:3 AS builder

RUN apk add --no-cache curl unzip ca-certificates

ARG POCKETBASE_VERSION

RUN echo "Using PocketBase version: $POCKETBASE_VERSION" \
    && curl -L -o /tmp/pb.zip "https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip" \
    && unzip /tmp/pb.zip -d /pb/ \
    && echo $POCKETBASE_VERSION > /pb/VERSION

# Final image
FROM alpine:3
LABEL org.opencontainers.image.source="https://github.com/pocketbase/pocketbase"

RUN apk add --no-cache ca-certificates unzip

COPY --from=builder /pb/pocketbase /pb/pocketbase
COPY --from=builder /pb/VERSION /pb/VERSION

EXPOSE 8080

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]