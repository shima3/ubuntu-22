#!/bin/bash
bin=$(dirname $0)
cd "$bin/.."
name=$(basename $PWD)
docker exec -it $name bash
