FROM maven:3.6.3-jdk-11

# Copy complete workspace
COPY . .

# Start maven build
RUN mvn -B -V -U -e clean verify -Dsurefire.useFile=false  -DargLine="-Djdk.net.URLClassPath.disableClassPathURLCheck=true"