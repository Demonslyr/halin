# base image
FROM node:13.5.0-stretch as base
RUN apt-get update && apt-get install -y yarn

# set working directory
RUN mkdir /app
WORKDIR /app
ENV PORT 3000

FROM base as build
# install and cache app dependencies
COPY . /app
RUN ls
RUN npm config set registry https://neo.jfrog.io/neo/api/npm/npm/
RUN yarn install --prod
RUN yarn build

FROM base AS final
COPY --from=build build ./build
RUN yarn install serve
EXPOSE 3000

ENV PATH /app/node_modules/.bin:$PATH

# start app
CMD ["serve", "-s build"]
