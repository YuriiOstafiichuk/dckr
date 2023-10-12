#!/bin/sh

# Start the server in the background and replies to client if success
(echo "server received the message"; cat) | nc -lvp 80
