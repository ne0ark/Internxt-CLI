# Internxt WebDAV Docker

Docker wrapper for the official [internxt/webdav](https://hub.docker.com/r/internxt/webdav) image, providing WebDAV access to Internxt Drive storage. Suitable for deployment on Unraid via Community Applications or any Docker host.

> **Migration Notice**: v2.0.0 switched from `@internxt/cli login` (broken in v1.6.0) to the official `internxt/webdav` image with ENV-based authentication. The old variables `INTERNXT_EMAIL`, `INTERNXT_PASSWORD`, and `INTERNXT_TOTP` are **deprecated and no longer supported**. Please use the new variables below.

## Quick Start

### Docker CLI

```bash
docker run -d \
  --name internxt-webdav \
  -e INXT_USER="your@email.com" \
  -e INXT_PASSWORD="your-password" \
  -p 3005:3005 \
  ne0ark/internxt-cli
```

### Docker Compose

```yaml
version: "3.8"
services:
  internxt-webdav:
    image: ne0ark/internxt-cli
    container_name: internxt-webdav
    environment:
      - INXT_USER=your@email.com
      - INXT_PASSWORD=your-password
      - INXT_OTPTOKEN=   # optional: OTP secret for automated 2FA
    ports:
      - "3005:3005"
```

## Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `INXT_USER` | Yes | — | Internxt account email address |
| `INXT_PASSWORD` | Yes | — | Internxt account password |
| `INXT_TWOFACTORCODE` | No | — | Current 2FA one-time code. Required if 2FA is enabled and `INXT_OTPTOKEN` is not set. |
| `INXT_OTPTOKEN` | No | — | OTP secret for auto-generating 2FA codes. Use for automated environments. |
| `WEBDAV_PORT` | No | `3005` | Port for the WebDAV server |
| `WEBDAV_PROTOCOL` | No | `https` | Protocol: `http` or `https` |

## Unraid Deployment

This image is available as an Unraid Community Applications template. In the Unraid UI, go to **Apps > Community Applications** and search for "Internxt WebDAV". Configure the environment variables through the template form.

Alternatively, you can deploy manually via Docker CLI or Compose as shown above.

## WebDAV Access

Once running, access WebDAV at:

- `http://localhost:3005` (default HTTP)
- `https://localhost:3005` (default HTTPS)

Connect using your Internxt credentials. Mount as a drive in your OS or use a WebDAV client.

## Troubleshooting

- **Container exits immediately**: Ensure `INXT_USER` and `INXT_PASSWORD` are set. Check logs with `docker logs internxt-webdav`.
- **2FA failures**: Use `INXT_OTPTOKEN` instead of `INXT_TWOFACTORCODE` for automated environments.
- **Port conflicts**: Change `WEBDAV_PORT` to an available port and update the `-p` mapping.

## License

MIT License — see [LICENSE](LICENSE) in this repository.
