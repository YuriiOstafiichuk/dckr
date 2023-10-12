#!/bin/sh

# Start the client in the background and send message to the server
(echo "message to the server"; cat) | nc $1 80

