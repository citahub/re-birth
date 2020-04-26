# ReBirth

[![Build Status](https://travis-ci.org/cryptape/re-birth.svg?branch=master)](https://travis-ci.org/cryptape/re-birth)
[![codecov](https://codecov.io/gh/cryptape/re-birth/branch/master/graph/badge.svg)](https://codecov.io/gh/cryptape/re-birth)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://www.rubydoc.info/github/cryptape/re-birth/master)

[English](./README.md) | 简体中文

[CITA](http://docs.citahub.com) 缓存服务器

适配 CITA v0.22 及以上

⚠️ NOTE: 如果从 CITA 0.17 更新到 0.18，更新完成之后执行 `rake daemons:sync:stop`，再执行 `rake zero18:update` 来更新数据，然后执行 `rake daemons:sync:start`，完成后重启 server 即可 😄

⚠️ NOTE: 当更新到这个版本的时候，应当执行 `bundle exec rake event_logs:fix_old` 去为已经存在的交易同步 event logs。

⚠️ NOTE: 执行 `bundle exec rake transactions:add_error_message` 来为旧的交易数据增加 `errorMessage`。

⚠️ NOTE: 如果从旧版本 CITA 更新到 0.20，更新完成之后应该执行 `rake daemons:sync:stop` 来停止同步服务，然后执行 `rake zero20:update` 来更新旧的数据，然后执行 `rake daemons:sync:start` 来启动同步服务，最后重启 server 即可。

## Docker

使用 [docker 🐳](https://docs.docker.com/install) 来运行

使用 `rails secret` 来生成 secret key 然后写入 `.env.local` 文件（查看 `.env` 文件来获取更多信息）
注意修改 `.env.local` 中的 sidekiq username 和 password

⚠️ 重要: 你的数据库文件将会保存在 docker/data

⚠️ 重要: Redis 的数据将会保存在 docker/redis

程序将会运行在 http://localhost:8888

```shell
$ make setup # 如果是第一次运行的话要执行该命令来初始化数据库
$ make up # 执行这个命令会在后台运行 docker 来运行程序
$ make update # 执行该命令以更新
```

更多信息可以参见 Makefile

## 依赖包

- [postgresql](https://www.postgresql.org/) 9.4 及以上
- 安装 [secp256k1](https://github.com/bitcoin-core/secp256k1.git)

  ```shell
  $ cd re-birth/tmp && git clone https://github.com/bitcoin-core/secp256k1.git && cd secp256k1 && ./autogen.sh && ./configure --enable-module-recovery && make && sudo make install && cd ../..
  ```

## 初始化程序

```shell
$ bundle
$ touch .env.local (在 `.env.local` 文件中覆盖 `.env` 中的项, 比如 DB_USERNAME, DB_PASSWORD and CITA_URL...)
$ rails db:setup (或者 rails db:create db:migrate db:seed)
```

## 运行测试

```shell
$ touch .env.test.local (测试环境下不会读取 `.env.local` 中的信息, 在 `.env.test.local` 覆盖 `.env` 中的项)
$ rails spec
```

## 执行程序

```shell
$ rails s

# 启动同步进程
$ rails daemons:sync:start
# 执行 `rails daemons:sync:stop` 来停止运行
# 执行 `rails daemons:sync:restart` 来重启服务
# 执行 `rails daemons:sync:status` 来查看状态
```

## Event Log 处理程序

在 `config/customs` 中创建一个 `.yml` 文件，查看 `config/customs/event_log.yml.sample` 来获取更多信息。举个例子，你的文件名为 `contracts.yml`，你可以执行 `bundle exec rake event_log:create[contracts]` 来创建表，然后执行 `bundle exec rake daemons:sync:restart` 来监听你的合约 😝

程序会同时使用 `address` 和 `topics` 来通过 jsonrpc 接口 [`getLogs`](http://docs.citahub.com/en-US/cita/rpc-guide/rpc#getlogs) 来筛选数据

## Deploy

可以用 [mina](https://github.com/mina-deploy/mina) 来部署

```shell
# 用你的环境变量名来代替 `dev` 
$ mina dev deploy
$ mina dev 'rake[daemons:sync:start]'
```

## 生成文档

```shell
$ bundle exec yard doc
$ bundle exec yard server
```

## API 文档
详见 [API Doc](./API_DOC.md)

## 贡献

### 创建 Bug 报告

遇到 Bug 时开一个 issue: [https://github.com/citahub/re-birth/issues/new](https://github.com/citahub/re-birth/issues/new)

并加上你使用的版本信息。

### 技术栈

通过阅读 [docs/tech_stack.md](docs/tech_stack.md) 了解此项目的编程语言、框架以及开发工具。

### 获取源码

```
git clone git@github.com:citahub/re-birth.git
```

### 编程风格

#### Coding style for Ruby

* coding style guide: [https://rubystyle.guide](https://rubystyle.guide)
* linter: [RuboCop](https://github.com/bbatsov/rubocop)
* code formatter: $ rubocop -x


#### Coding style for Docker

* coding style guide: https://github.com/Haufe-Lexware/docker-style-guide
* formatter: https://www.fromlatest.io/
* best-practices: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

#### Coding style for Makefile

* coding style guide: https://style-guides.readthedocs.io/en/latest/makefile.html
* tutorial: https://makefiletutorial.com/
* conventions: https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
* best-practices: https://suva.sh/posts/well-documented-makefiles/


### 运行测试

```
$ rails spec
```

### 提交代码

#### 代码提交流程

[GitHub Flow](https://help.github.com/en/articles/github-flow), [Understanding the GitHub flow](https://guides.github.com/introduction/flow/)

#### 代码提交规范

use [git-style-guide](https://github.com/agis/git-style-guide) for Branches, Commits,Messages, Merging
