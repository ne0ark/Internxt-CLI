FROM internxt/webdav:latest

LABEL org.opencontainers.image.source="https://github.com/ne0ark/Internxt-CLI"
LABEL org.opencontainers.image.description="Internxt WebDAV Docker wrapper for Unraid"

ENV INXT_USER=""
ENV INXT_PASSWORD=""
ENV INXT_TWOFACTORCODE=""
ENV INXT_OTPTOKEN=""
ENV WEBDAV_PORT="3005"
ENV WEBDAV_PROTOCOL="https"

EXPOSE 3005
