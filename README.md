patchstorage-lv2-builder
==================

# Building through Docker (recommended)

The Docker builder images are available on https://hub.docker.com/repositories/patchstorage, and are pulled by the `./docker-init` script as shown in Initial setup section.

## Requirements

* Linux or Mac OS based computer (or Linux running in a VM)
* Latest Docker Desktop or Docker Engine set up on your platform (https://docs.docker.com/get-docker/)
* Docker Compose plugin (https://docs.docker.com/compose/install/)
* git

In order to verify your environment is ready to go, running the following commands should give no errors:

```
git
docker image ls
```

## Initial setup

Clone this repository and its submodules:

```
git clone https://github.com/patchstorage/patchstorage-lv2-builder
cd pathstorage-lv2-builder

# Don't forget to get the submodules, or plugin builds will fail!
git submodule init
git submodule update

# Run the below script to pull the precompiled images.
./docker-init
```

## Building plugins with Docker

Run `./docker-build <platform> <plugin_name>` to trigger a build of a plugin.

* `<platform>` is one of `x86_64`, `raspberrypi3_armv8`, `raspberrypi4_aarch64`.
* `<plugin_name>` must match the folder name as in `plugins/package/` directory.
* Build results go to `docker-workdir/<platform>/`.

For example:

```
./docker-build raspberrypi3_armv8 abgate
```

The build results will be in `docker-workdir/raspberrypi3_armv8/abGate.lv2`

## Building plugins for all supported platforms with Docker

Run `./docker-build-all <plugin_name>` to trigger builds on every supported platform.

* `<plugin_name>` must match the folder name as in `plugins/package/` directory.
* Build results go to `docker-workdir/<platform>/`.

For example:

```
./docker-build-all abgate
```

The build results will be in:

* `docker-workdir/x86_64/abGate.lv2`
* `docker-workdir/raspberrypi3_armv8/abGate.lv2`
* `docker-workdir/raspberrypi4_aarch64/abGate.lv2`

==================

This repository contains buildscripts for the toolchain and libraries to build LV2 plugins to run on MOD software.

There are several dependencies:
 - gcc & g++
 - git
 - subversion
 - hg/mercurial
 - autoconf
 - automake
 - bzip2
 - lzma
 - binutils
 - libtool
 - ncurses
 - rsync
 - wget
 - bc
 - bison
 - flex
 - help2man
 - gawk
 - gperf
 - texinfo

If you're running a debian based system you can install all dependencies by running:
```
sudo apt install acl bc curl cvs git mercurial rsync subversion wget \
bison bzip2 flex gawk gperf gzip help2man nano perl patch tar texinfo unzip \
automake binutils build-essential cpio libtool libncurses-dev pkg-config python-is-python3 libtool-bin
```

Note that `libtool-bin` and `python-is-python3` are not available on old distros.<br/>
If that is the case for you, simply skip these packages but install everything else.

To begin simply run the bootstrap.sh, it will print out a list of available platforms that can be used as an argument.<br/>
The bootstrap.sh script will build the toolchain (ct-ng) and buildroot.<br/>
Depending on your machine it can take more than 1 hour.<br/>

All files will be installed in `~/mod-workdir`.<br/>
Set the 'WORKDIR' environment variable before bootstraping if you wish to change that.

After the bootstrap process is complete, you can start building plugins.<br/>
See the 'plugins/package' folder in this repository for some examples.

### Building plugins

To build a plugin, run:<br/>
```
./build <platform> <plugin-package>
```

Where `platform` is one of the available platforms `plugin-package` is a folder inside the `plugins/package` directory.

If everything goes well, you will have the final plugin bundle in `~/mod-workdir/<platform>/plugins`.<br/>

To push the build plugin onto a MOD Device, run:<br/>
```
./build <platform> <plugin-package>-publish
```
Or if you feel like doing it manually, you can run something like:
```
cd /path/to/mod-workdir/plugins # adjust as needed
tar czf bundle1.lv2 bundle2.lv2 | base64 | curl -F 'package=@-' http://192.168.51.1/sdk/install; echo
```

For cleaning a build directory, run:<br/>
```
./build <platform> <plugin-package>-dirclean
```

NOTE: If you want to build the provided plugins in this repository you'll need to enable git submodules, like this:
```
git submodule init
git submodule update
```

### Validating plugins (experimental)

It's possible to test a few aspects of a plugin. It's important that the plugin has been built successfully before running this test. 

Firstly, the test can be used for ttl syntax validation. This is done through lv2/sord_validate.
These tools need to be installed on the system. 
On a Debian based system these can be installed by running:<br/>
```
sudo apt install lilv-utils sordi
```
Secondly, this test can also be used for runtime tests for all x86_64 builds.

To do the test, run:<br/>
```
./validate <platform> <plugin-package>
```

The runtime test (for `x86_64` plugins) can also be combined with valgrind for detecting memory issues.

For running this test do:<br/>
```
VALGRIND=1 ./validate <platform> <plugin-package>
```
