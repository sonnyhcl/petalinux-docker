# petalinux-docker
package petalinux tools into docker image

> If you feel this is helpful for you, please star me right now :)
>
> <https://github.com/sonnyhcl/petalinux-docker>

## Prerequisite
> make sure you have pre-installed docker. If not, <https://get.docker.com/> may be helpful.

```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```
## Usage
### run petalinux in one line docker command
- `source settings.sh` has already been done in bashrc
- the default working directory is `/home/plnx/project`, you can mount a host directory to persist your data.
- the whole docker image is about 8GB, so make sure your network works in the right way.
```console
docker run -ti -v `pwd`:/home/plnx/project sonnyhcl/petalinux
```
### what you can do in the container:
```
petalinux -t project -s <path-to-bsp> -n <project-name>
cd <project-name>
petalinux-build # this will take a long time
```
## Avaiable versions
- <https://hub.docker.com/r/sonnyhcl/petalinux/tags/>
- base image: ubuntu 16.04
- petalinux version:2018.2

## Build you own images
```
./build-docker-image.sh <petalinux_run_dir> <version>
```
#### example
```
./build-docker-image.sh `pwd` 2018.2
```

## Reference
- <https://github.com/xaljer/petalinux-docker>
- <https://blog.csdn.net/elegant__/article/details/76162435> in Chinese
- <https://github.com/alexhegit/petalinux-v2018.2-docker>
- [ug1144-petalinux-tools-reference-guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug1144-petalinux-tools-reference-guide.pdf)
