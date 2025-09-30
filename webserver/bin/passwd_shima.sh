#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
bin/exec.sh useradd -m -s /bin/bash shima
bin/exec.sh usermod --password '$y$j9T$whNZTgxbGdeIJuWEUSkJA0$0fr5b1BLfAbV4qd8GMzM8JOg5vle2spWcuUI3xW9jCD' shima

