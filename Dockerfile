FROM restic/restic

RUN apk add --update --no-cache \
    bash \
    curl \
    gettext

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.2/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=2319da694833c7a147976b8e5f337cd83397d6be

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

ENV SCHEDULE="12 3 * * *"
ENV HOSTNAME=unraid
ENV DRYRUN=

COPY --chmod=755 entry.sh /entry.sh
COPY crontab.tmpl /etc/cron.d/crontab.tmpl
COPY --chmod=755 do-backup.sh /usr/local/bin/do-backup.sh

ENTRYPOINT [ "/entry.sh" ]