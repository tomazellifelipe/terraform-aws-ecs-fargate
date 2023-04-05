#!/usr/bin/env python3

import re
import subprocess
from pathlib import Path


# Defining doc file path
module_path = Path(str(Path(__file__).parent.absolute()) + "/..").resolve()
doc_path = Path(str(module_path) + "/README.md")

# Run terraform-docs from docker
try:
    command_output = subprocess.run(
        [
            "docker run "
            + "-v "
            + str(module_path)
            + ":/terraform "
            + "quay.io/terraform-docs/terraform-docs:latest "
            + "markdown /terraform"
        ],
        check=True,
        shell=True,
        # capture_output=True                           # only works on Python >= 3.8
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,  # added for Python 3.6 compatibility
    )
except subprocess.CalledProcessError as e:
    print(e.output)

# Open for reading
with open(doc_path, "r") as doc_file:
    data = doc_file.read()
    data = re.sub(
        r"<!--- TERRAFORM DOCS BEGIN -->.*?<!--- TERRAFORM DOCS END -->",
        "<!--- TERRAFORM DOCS BEGIN -->\n"
        + str(command_output.stdout)[2:-1]
        + "<!--- TERRAFORM DOCS END -->",
        data,
        flags=re.DOTALL,
    )

# Open for writing, truncating the file first
with open(doc_path, "w") as doc_file:
    doc_file.write(data)
