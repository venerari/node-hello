FROM node:20-alpine

WORKDIR /app

# Read the package version and unpack the matching tarball
COPY package.json /tmp/package.json
COPY package-lock.json /app/package-lock.json
COPY node-hello-*.tgz /tmp/
RUN APP_VERSION=$(node -p "require('/tmp/package.json').version") \
    && tar -xzf "/tmp/node-hello-${APP_VERSION}.tgz" -C /app --strip-components=1 \
    && rm -f /tmp/node-hello-*.tgz /tmp/package.json

RUN npm ci --omit=dev --ignore-scripts
RUN chown -R node:node /app

USER node

EXPOSE 3000

CMD ["npm", "start"]