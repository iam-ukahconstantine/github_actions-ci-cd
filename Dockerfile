# Select a base image to build the application
FROM golang:1.22.5 AS builder

# Specify which folder would house the application dependencies and application
WORKDIR /app

# Copy the dependencies in the go.mod file into the /app folder. 
COPY go.mod .

# Download additional dependencies
RUN go mod download

# Copy the source code into the /app
COPY . .

# Build the application. NB: You can specify any name 
RUN go build -o webapp .

# Use a distroless image to compile the application
FROM gcr.io/distroless/base-debian12

# Copy the application artifact from the webapp to the default directory
COPY --from=builder /app/webapp .

# Copy the static file content into a new static folder
COPY --from=builder /app/static /static

# Use the exposed port
EXPOSE 8080

CMD [ "./webapp" ]
