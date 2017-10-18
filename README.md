# cleo_devops
This repository contains scripting to build a Harmony instance on linux (ubuntu) either in virtualbox or aws. You will need to have vagrant installed in your local environment. If installing locally on virtualbox, you will also need to pre-install and configure virtualbox. For aws, you'll need to configure aws credentials as detailed here http://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html
Note that you will need to create both a credentials file and config file.

To build in virtualbox:
`./buildit.sh` the first time (which downloads the installer) and if installer is already available, `vagrant up`

To build in aws:
`vagrant up --provider aws`
