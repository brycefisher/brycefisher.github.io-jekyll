#!/bin/bash -eu

let PORT=4000

echo "Starting jekyll in the background..."
docker run -d -v "$(pwd):/src" --name jekyll -p "$PORT:$PORT" grahamc/jekyll serve -H 0.0.0.0 || echo "Already running"
xdg-open "http://127.0.0.1:$PORT/"
