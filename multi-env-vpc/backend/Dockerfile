FROM node:12
# backend dockerbuild

COPY . .

RUN npm install
RUN npm install -g pm2

# 테스트
RUN npm run test

# 빌드
RUN npm run build

EXPOSE 8080

ENTRYPOINT ["pm2-runtime", "start", "ecosystem.config.js"]