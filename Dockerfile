FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
# this may add extra cache memory
RUN npm install 


FROM node:20.19.5-alpine3.21
# Create a group and user
WORKDIR /opt/server
RUN addgroup -S dotmart && adduser -S dotmart -G dotmart && \
    chown -R dotmart:dotmart /opt/server
EXPOSE 8080
LABEL com.project="dotmart" \
      component="catalogue" \
      created_by="sivakumar"
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
COPY --from=build --chown=dotmart:dotmart /opt/server /opt/server
USER dotmart
CMD ["server.js"]
ENTRYPOINT ["node"]