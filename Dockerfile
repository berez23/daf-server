# You should always specify a full version here to ensure all of your developers
# are running the same version of Node.
FROM node:8

# The base node image sets a very verbose log level.
ENV NPM_CONFIG_LOGLEVEL warn

#RUN apt-get update && apt-get install -y \
#  git-core   
  #&& apt-get install -y build-essential python

#copy the file 
COPY . .

#RUN npm install -g node-gyp  

# Copy all local files into the image.
#RUN git clone https://github.com/esterpantaleo/daf-server

WORKDIR /daf-server

#RUN git checkout production

RUN npm install

CMD [ "npm", "start" ]

# Build for production.
#RUN npm run build --production

# Install `serve` to run the application.
RUN npm install -g serve

# Set the command to start the node server.
CMD serve -l 4000 #-s build

# Tell Docker about the port we'll run on.
EXPOSE 4000
