FROM node:10-alpine

WORKDIR /app

RUN npm install -g contentful-cli

COPY ./nodeApp/package.json .
RUN npm install

COPY ./nodeApp/ .

USER node
EXPOSE 3000

# CMD ["npm", "run", "start:dev"]
ENTRYPOINT ["npm", "run", "start:dev"]

