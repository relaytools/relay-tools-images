FROM node:18-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/relaytools/relaycreator.git .

RUN npm i
RUN npm run build

CMD ["npm", "start"]