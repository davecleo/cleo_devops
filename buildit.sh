#!/bin/bash
curl "http://www.cleo.com/SoftwareUpdate/harmony/release/jre1.8/InstData/Linux(64-bit)/VM/install.bin" -o installers/Harmony.bin
vagrant up harmony
