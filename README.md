# get-mirrors


# How to use

```shell
$ git clone https://github.com/GitaiQAQ/get-mirrors.git
$ cd get-mirrors
$ ./install.sh
```

## In Dockerfile

```
...

RUN curl -Ls -o get-mirrors.tar.gz `curl "https://api.github.com/repos/GitaiQAQ/get-mirrors/releases/latest" | grep "tarball_url" | cut -d "\"" -f 4` \
        && tar -xzf get-mirrors.tar.gz \
        && cd GitaiQAQ-get-mirrors-* \
        && bash ./install.sh

...
```

# For Advanced Package Tool(apt)

Mirrors:

* mirrors.aliyun.com
	* debian
		* jessie
		* stretch
		* wheezy
	* ubuntu
		* bionic
		* trusty
		* xenial

# For Node Package Manager(npm)

Mirrors:

* registry.npmjs.org
* registry.npm.taobao.org(while install cnpm)
* r.cnpmjs.org

# For The Python Package Index (PyPI)

Mirrors:

* mirrors.aliyun.com
* pypi.mirrors.ustc.edu.cn
* pypi.tuna.tsinghua.edu.cn

# For docker

Script `set_mirror.sh` forked form Daocloud accelerator

Set `$REGISTRY_MIRRORS` in env before install

```shell
$ REGISTRY_MIRRORS=http://b2c3765b.m.daocloud.io ./install.sh
```