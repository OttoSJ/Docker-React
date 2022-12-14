FROM node:16-alpine as builder

# The WORKDIR creates a directory that will store all directories and files for the simple node app inside the docker image
WORKDIR /app

# Coping the package.json file here keep from installing npm unless there have been dependencies add to the project
COPY ./package.json .

RUN npm install

# Files in the simple-node-app project are not included in the image and need to be copied into the container before the npm install so that all the dependencies are downloaded based on the package.json. That is what this copy command is doing. 
# Note: In a development environment this copy command is redundent as we are using volumes in the yml file which copies all the dir/files already example: (.:/app).
COPY ./ ./

RUN npm run build

FROM nginx 
COPY --from=builder /app/build /usr/share/nginx/html
