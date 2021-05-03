FROM node:14
WORKDIR /usr/src/app
COPY package*.json app.js ./
RUN npm init -y
RUN npm install express

RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]
