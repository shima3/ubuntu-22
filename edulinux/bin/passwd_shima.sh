#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
bin/exec.sh useradd -m -s /bin/bash shima
bin/exec.sh usermod --password '$y$j9T$ejpZCTUF/.oOCoWFC0Zpm0$cMqkCL6K7JiiF9BnQQwk8FP3bFkKsRtX//GidKXxuiB' shima
