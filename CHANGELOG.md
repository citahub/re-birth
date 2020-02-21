# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v0.4.0](https://github.com/citahub/re-birth/releases/tag/v0.4.0) ([compare](https://github.com/citahub/re-birth/compare/v0.3.0...v0.4.0))

### Added
- Add /api/v2/transactions ([32104c4](https://github.com/citahub/re-birth/commit/32104c4a60086ed1b8e08b3e86a234fb8c34021f) by classicalliu).

### Fixed
- Fix typo ([a20574e](https://github.com/citahub/re-birth/commit/a20574efe1c5c2796a5952d9159af5b8d9817337) by CL).
- Fix: fix /api/v2/blocks in api doc ([99ec6d8](https://github.com/citahub/re-birth/commit/99ec6d803af928bf8807e02a9320770890072bce) by classicalliu).

### Misc
- Upgrade sdk for v0.24.0 v2 support ([f955b20](https://github.com/citahub/re-birth/commit/f955b20af4b90ed1d1125a5d729fa305b877e9f7) by classicalliu).
- Disable recover mode and only support v0.22 and above ([6cec7ca](https://github.com/citahub/re-birth/commit/6cec7ca8a2bce194a131df2d8f979fc6f14bda8b) by classicalliu).
- Better expression ([37758f9](https://github.com/citahub/re-birth/commit/37758f9e237bfe8edd0730295e9235e205d7db37) by CL).
- Error: in file ./.env: environment variable name 'loop_interval ' may not contains whitespace. ([c116b3b](https://github.com/citahub/re-birth/commit/c116b3bd0afc9b7a3a9dc8e77f7af6951c04bd86) by sunfjun).


## [v0.3.0](https://github.com/citahub/re-birth/releases/tag/v0.3.0) ([compare](https://github.com/citahub/re-birth/compare/0.2.0...v0.3.0)) - 2019-04-25

### Added
- Add /v2/api/blocks ([c62ad8f](https://github.com/citahub/re-birth/commit/c62ad8f48968ffbf2fce91fd0d1786a5b692d8e3) by classicalliu).
- Add chinese version of readme ([f2176d0](https://github.com/citahub/re-birth/commit/f2176d00514a7f47c0ddae0236fd0efb54c99d59) by classicalliu).
- Add api for cita rpc url and websocket url info ([d9687da](https://github.com/citahub/re-birth/commit/d9687da81f0f98eba9adbeb1ea9c928060fc36ae) by classicalliu).
- Add `timestamp`, `quota_used`, `proposer` to blocks and add `timestamp` to transactions ([02e1b38](https://github.com/citahub/re-birth/commit/02e1b38d4bac49b00779f746c55ed607cce7d9df) by classicalliu).
- Add sidekiq auth for production env. ([1d43716](https://github.com/citahub/re-birth/commit/1d43716153e06856d10200739faffce843c5fc25) by classicalliu).
- Add sidekiq and redis to docker compose. ([1dd129e](https://github.com/citahub/re-birth/commit/1dd129e11ffca4bec40ed43210c14e2c0415af7c) by classicalliu).
- Add root url info to instead of not found ([d57425b](https://github.com/citahub/re-birth/commit/d57425b20ade1e89d93c0092d823fbf6e570fe6b) by classicalliu).
- Add timestamp in erc20 transfers ([1d7aec5](https://github.com/citahub/re-birth/commit/1d7aec5e04643b797173d29ead340e5586d37ffa) by classicalliu).
- Add readme: add event log show api ([b703cc6](https://github.com/citahub/re-birth/commit/b703cc6d98766b4c4a16d398f24eb17aa0f514aa) by classicalliu).
- Add event log show api ([97eea5c](https://github.com/citahub/re-birth/commit/97eea5c2a709536c14a085fae88e4ae046e1fc12) by classicalliu).
- Add errormessage to transactions ([02b3cc6](https://github.com/citahub/re-birth/commit/02b3cc68619d36d90a186805659add2da3f0267b) by classicalliu).

### Changed
- Change loop interval ([78da98f](https://github.com/citahub/re-birth/commit/78da98fa6949777cea979e59933bc024fe53dc96) by classicalliu).
- Change `block_number`, `value`, `quota_used` and so on to decimal number ([d8cb2e4](https://github.com/citahub/re-birth/commit/d8cb2e4c23e37278ddb7316b32dafc3bced641a9) by classicalliu).
- Change blocks, transactions, event_logs, erc20_transfers pkey and fkey. ([3927b03](https://github.com/citahub/re-birth/commit/3927b03487fb7acc5f2b42262d74a93d243d44a6) by classicalliu).

### Fixed
- Fix docker-compose log file not found problem ([e43a94c](https://github.com/citahub/re-birth/commit/e43a94c61d5d62d0c9b17586991cc41cee93f537) by classicalliu).
- Fix sync log not write problem add fix sync interval ([7e78153](https://github.com/citahub/re-birth/commit/7e78153136370ee869e1bade03e82a7cdbaa26e5) by classicalliu).
- Fix `tx.event_logs` and `tx.erc20_transfers` null problem ([7ecf510](https://github.com/citahub/re-birth/commit/7ecf510858d0b0c5e7095e681fa16b10aa2fbf0b) by classicalliu).
- Fix ws url scheme ([0b1ad09](https://github.com/citahub/re-birth/commit/0b1ad0972986bee7dfa75f7ce0fb9dd9e8260aa1) by classicalliu).
- Fix tests for `save_transaction` params ([3a2eb9d](https://github.com/citahub/re-birth/commit/3a2eb9df8dac07172f52b6167aaaeb64036aad98) by classicalliu).
- Fix for old name `cita_hash` ([d2c9d13](https://github.com/citahub/re-birth/commit/d2c9d1365b4b8c4566301615519ff974ebf80ebe) by classicalliu).
- Fix bug: erc20_transfers persist ([47f2330](https://github.com/citahub/re-birth/commit/47f2330e341562ba786a5028931a50eb91395c0e) by classicalliu).

### Removed
- Remove useless balance and abi ([e41229b](https://github.com/citahub/re-birth/commit/e41229bcde2748688f1a6781a41b4fc6e2a3ea89) by classicalliu).
- Remove include block from transaction controller ([92fe6a2](https://github.com/citahub/re-birth/commit/92fe6a2738f4830bf8d925f21dbfb4bf87217021) by classicalliu).
- Remove get transaction rpc call when save transaction ([947ef3b](https://github.com/citahub/re-birth/commit/947ef3bf2c6893ae5b5fb2f639e410f7beb50279) by classicalliu).
- Remove error scope in transaction receipt ([e6826d2](https://github.com/citahub/re-birth/commit/e6826d2bc844ded482d2de25c093c7a122bdd356) by classicalliu).

### Misc
- Format api doc ([fc990c8](https://github.com/citahub/re-birth/commit/fc990c8cbe7da0ec567b99f8e066d1d0bdafcec0) by classicalliu).
- Rename /v2/blocks params ([f1feb43](https://github.com/citahub/re-birth/commit/f1feb43d58c3f84c7007ceed94b74f2dda1e6e76) by classicalliu).
- Transform v2/blocks keys ([d8f90c3](https://github.com/citahub/re-birth/commit/d8f90c3e4a5de9e92628bcaea04bd0952cebf39c) by classicalliu).
- Update nokogiri ([6546369](https://github.com/citahub/re-birth/commit/654636964fc4f02c7f40182ee25644004809ccbc) by classicalliu).
- Update rails to fix security problem ([f7a302c](https://github.com/citahub/re-birth/commit/f7a302cc5741dd04f6fbc2afadc85e73b219c102) by classicalliu).
- Split api doc to a single file ([fbfdb73](https://github.com/citahub/re-birth/commit/fbfdb737196a18f64bb04f4b08d469c83d21cccf) by classicalliu).
- Replace cita doc url ([be88c07](https://github.com/citahub/re-birth/commit/be88c07e7813d6c6f60068be3268d51a00b13a11) by classicalliu).
- Replace `appchain.rb` with `cita-sdk-ruby` ([711fc5c](https://github.com/citahub/re-birth/commit/711fc5c1f638eadb4e3da33a3b4910779955d81f) by classicalliu).
- Update erc20 transfer api doc ([d39afc5](https://github.com/citahub/re-birth/commit/d39afc5ab83e17e85a2b69c7b400a46cc6c93a97) by classicalliu).
- Lock appchain.rb version to 0.2.0 ([f92ff26](https://github.com/citahub/re-birth/commit/f92ff260a8d0e3fd085e7e5827d4a1cfa0a600ef) by classicalliu).
- Rename `infos` to `info` ([ec42a11](https://github.com/citahub/re-birth/commit/ec42a111c1aff74f3e3cb25a8a06cd31d1eb9e1d) by classicalliu).
- Update rails version to 5.2.2 ([dfe0f83](https://github.com/citahub/re-birth/commit/dfe0f8324638e7712c3e2cf5b1c3ff3bfb57c682) by classicalliu).
- Rjust tx value to size 64 ([30fc089](https://github.com/citahub/re-birth/commit/30fc0890c64601dca0ce7ab4153a90abb76473e6) by classicalliu).
- Update controllers and serializers for changed pkey ([419edd2](https://github.com/citahub/re-birth/commit/419edd28994c32eab72200760a242c2fcb909929) by classicalliu).
- Using `push_bulk` to push a list of workers, it performs better ([aa9b119](https://github.com/citahub/re-birth/commit/aa9b11973c076475b58cf0e36a3def139d31deac) by classicalliu).
- Return error object when rpc error in tx ([5e59ab4](https://github.com/citahub/re-birth/commit/5e59ab4c11cf806fa7f97c197819dc0640eec1d2) by classicalliu).
- Save tx and it's event logs in one db transaction ([179305b](https://github.com/citahub/re-birth/commit/179305b6571d3c035d67cf24c44a5726bb8c404a) by classicalliu).
- Retry when save tx or event logs failed ([3722786](https://github.com/citahub/re-birth/commit/3722786677700d71f57d423a3b630aaa516434f2) by classicalliu).
- Skip check queue size in test ([e5e97fa](https://github.com/citahub/re-birth/commit/e5e97fa19505026eae1ad2c4ba5286c7479a9156) by classicalliu).
- Insert block in sidekiq and handle system timeout and not ready error ([3e6e43b](https://github.com/citahub/re-birth/commit/3e6e43b6aae75a90adee8477e0d2330fad7bc40d) by classicalliu).
- Don't enable experimental for secp256k1, create pids dir before start docker. ([1f6b911](https://github.com/citahub/re-birth/commit/1f6b9116cf045a2bf58f949332785cfb728caac4) by classicalliu).
- Update rails to 5.2.1.1 for security. ([bdedfa7](https://github.com/citahub/re-birth/commit/bdedfa7db0329a45dbf17a6a28ddfec88bdaac4f) by classicalliu).
- Update readme for fix a display issue. ([7b67e53](https://github.com/citahub/re-birth/commit/7b67e5387afc9b78d305a4a9ae6ef1f303aa4a77) by classicalliu).
- Set default redis namespace to nil. ([309ff73](https://github.com/citahub/re-birth/commit/309ff73db1d92da71fa2f04005708a48508d6e25) by classicalliu).
- Update readme for sidekiq and redis infos. ([b6dd3fd](https://github.com/citahub/re-birth/commit/b6dd3fde195f2e0233cdf84d169dbeb349ca3ce0) by classicalliu).
- Reset sidekiq pid path in deploy script. ([be77127](https://github.com/citahub/re-birth/commit/be771274e564258924b6d94df438f24fcf6a1ea8) by classicalliu).
- Using sidekiq to process transactions and event logs. ([7c80caf](https://github.com/citahub/re-birth/commit/7c80cafe5877b4c6bce769cfc3be9fe20c92e015) by classicalliu).
- Using appchain.rb to make rpc calls and replace message decode ([0066a2b](https://github.com/citahub/re-birth/commit/0066a2be357286275fbc53d798fa9200188c0bf0) by classicalliu).
- Update docker ruby version. ([eab20cb](https://github.com/citahub/re-birth/commit/eab20cb9ca8802a82e1742f9baecdd76e9d6a1d2) by classicalliu).
- Update deploy script ruby version. ([744e546](https://github.com/citahub/re-birth/commit/744e54617bc6e8bb0ac9a6cbd21d42a32ad04d15) by classicalliu).
- Update ruby version to 2.5.3 and update gems. ([2a6e033](https://github.com/citahub/re-birth/commit/2a6e033bcbb7d086357e7b833db87beb49441dfa) by classicalliu).
- Update readme for 0.20 changes ([9817876](https://github.com/citahub/re-birth/commit/9817876362435ecc393efdeab71228b4348becf1) by classicalliu).
- Rename gas_used to quota_used ([727bcd3](https://github.com/citahub/re-birth/commit/727bcd3e1734ce59cb7c813c1e67d3f184cc34e5) by classicalliu).
- Update serializer chain_id ([f549b8b](https://github.com/citahub/re-birth/commit/f549b8b04978f26c671bd892be9ae2a25b384e23) by classicalliu).
- Update `loofah` version to 2.2.3 for security ([d5506e4](https://github.com/citahub/re-birth/commit/d5506e4903decbc26a5e8c6eede65c806e1049d1) by classicalliu).
- Support cita 0.20 forks (version 0 & version 1) ([628500b](https://github.com/citahub/re-birth/commit/628500b65faee8316f7c56a863a4ef5706555158) by classicalliu).
- Update homepage message ([a4dcdd5](https://github.com/citahub/re-birth/commit/a4dcdd509056e56724a1880dca29208765324610) by James Chen).
- Move cors config from application.rb to initializers(rails api only standard) ([1305f11](https://github.com/citahub/re-birth/commit/1305f114f0dd5c75ae454f4590600bbf2f90ed7a) by classicalliu).
- Custom to api only structure ([6bccd51](https://github.com/citahub/re-birth/commit/6bccd511ebaba746332c1506834e245e95c487c4) by classicalliu).
- Set max_per_page to 100 ([96a2386](https://github.com/citahub/re-birth/commit/96a2386aae373a95eda032b5bca3f53fff6f509c) by classicalliu).
- Update readme: errormessage in api ([e69ec83](https://github.com/citahub/re-birth/commit/e69ec836c84d4ce8cf0d133f4fd24f074ce143e0) by classicalliu).
- Update readme: add error messages ([9145469](https://github.com/citahub/re-birth/commit/9145469d7fd1a7a18a23b4e611110e81be6d65a1) by classicalliu).
- Upgrade gem: nokogiri ([00fbbba](https://github.com/citahub/re-birth/commit/00fbbba36e1ae0edb993b0afac26426ec969d3ee) by classicalliu).
- Update ci: delete branch limit ([de6fdfb](https://github.com/citahub/re-birth/commit/de6fdfb3b4b1ee233ac1e5cc5903c6472804898f) by classicalliu).


## [0.2.0](https://github.com/citahub/re-birth/releases/tag/0.2.0) ([compare](https://github.com/citahub/re-birth/compare/v0.1.1...0.2.0)) - 2018-09-27

### Added
- Add rubocop and fix ([05a7a54](https://github.com/citahub/re-birth/commit/05a7a542fff9e4a8bf56ec518b24c6d6a602c070) by classicalliu).
- Add an api: find transaction with hash ([d58999e](https://github.com/citahub/re-birth/commit/d58999e1865809bc2647a0b5828682fbd292b0c5) by classicalliu).
- Add chainid and chainname to transaction and transfer list ([8c6c65e](https://github.com/citahub/re-birth/commit/8c6c65e930004ce0530526b85fca648303a388aa) by classicalliu).
- Add erc20 event log process ([be5e744](https://github.com/citahub/re-birth/commit/be5e744ff2931072af0360258f65d0d607754651) by classicalliu).
- Add block & transaction reference to event logs ([92563f8](https://github.com/citahub/re-birth/commit/92563f86254c71b7ccf447fe85e02ce1cc08c418) by classicalliu).
- Add event logs, sync event logs while sync transactions ([2f1de8c](https://github.com/citahub/re-birth/commit/2f1de8c109dbbd9446ea1130395df1fe44bb4501) by classicalliu).
- Add healthy check ([67b1259](https://github.com/citahub/re-birth/commit/67b1259ea9751da4dfd2cb466d25355177f93a35) by classicalliu).
- Add release branch to ci ([50e0d52](https://github.com/citahub/re-birth/commit/50e0d52f9d86cce2a173cb1ff28dcabfc98ebb71) by classicalliu).
- Add staging and production deploy script ([3eb295d](https://github.com/citahub/re-birth/commit/3eb295d9c5ff753b0da1ef70603c42e8be230bfd) by classicalliu).

### Documented
- Docker support 🐳 ([522afce](https://github.com/citahub/re-birth/commit/522afceb0f8873222481d605bb50a843dbf7f84a) by classicalliu).

### Fixed
- Fix: raise error when result is nil in fix_old task ([4e94730](https://github.com/citahub/re-birth/commit/4e94730d1d16f69fd3060c622ae60e6719c382e4) by classicalliu).
- Fix brakeman bug ([3b5b1e9](https://github.com/citahub/re-birth/commit/3b5b1e98f05be67972a35e5d0456774ce7101ec6) by classicalliu).
- Fix factorybot/attributedefinedstatically ([aa9ec02](https://github.com/citahub/re-birth/commit/aa9ec021bb32d4cb7e9998da3a40d4a985d2ce89) by classicalliu).
- Fix two `before_script` problem in ci config ([21f96a3](https://github.com/citahub/re-birth/commit/21f96a34d5dc97d8edb3e099bde562aa853bd162) by classicalliu).
- Fix message_spec ([eaf6bb7](https://github.com/citahub/re-birth/commit/eaf6bb7c77c11a4aab0dcea25e82302bee9dc9b5) by classicalliu).
- Fix proposals order, may strange in microscope... ([3399d2e](https://github.com/citahub/re-birth/commit/3399d2ea0eb98cacc7b57f5f3b65d757d13bf0e2) by classicalliu).
- Fix typo: tendermint => tendermint ([72dfac6](https://github.com/citahub/re-birth/commit/72dfac6ef5d6f031434e14eb0f4c0027f99718fc) by classicalliu).
- Fix upgrade to cita v0.18 migration, drop old and create new one, for work with pg v9.4 ([932a2aa](https://github.com/citahub/re-birth/commit/932a2aa468c4df751e328ae8f54e9ef60ce77990) by classicalliu).
- Fix test db host ([64cbcce](https://github.com/citahub/re-birth/commit/64cbcce1852ab44cfaf676d3c0aa53198031362d) by classicalliu).

### Removed
- Remove event log (no use anymore...) ([f161f8a](https://github.com/citahub/re-birth/commit/f161f8aefa8849e36dacbaafde2e920bcd9c3416) by classicalliu).
- Remove migration and model files for event logs... ([446f072](https://github.com/citahub/re-birth/commit/446f0729fb4d9f03b53cc88a7714a9a725a46f6e) by classicalliu).
- Remove metadata, it's no need to save. ([d957f78](https://github.com/citahub/re-birth/commit/d957f78e22547648554dedd21e8f52e3c865f516) by classicalliu).

### Misc
- Delete unused (commented out) gems ([95ebf50](https://github.com/citahub/re-birth/commit/95ebf50eee11e763150a41b670d59f7258dbc32f) by James Chen).
- Specify rubocop version ([3380c2e](https://github.com/citahub/re-birth/commit/3380c2eda48cd4d4f473dccb1fed4a74a5c6f1f8) by James Chen).
- Bug fix: select event logs ignore case when process erc20 transfers ([ce36476](https://github.com/citahub/re-birth/commit/ce364769b673133afb25f07b97a1e64925a9ed01) by classicalliu).
- Save erc20 transfer address in lower case ([1793fc3](https://github.com/citahub/re-birth/commit/1793fc30fc27b63fe558175e2ce0c2ce277888b3) by classicalliu).
- Update comment for before_script in .travis.yml ([17b6775](https://github.com/citahub/re-birth/commit/17b6775c03fc41146696b1ec05d918e74d8e1cff) by RainChen).
- Set default cita_url to localhost ([ee9a505](https://github.com/citahub/re-birth/commit/ee9a505ae6babb5f5fbe365a3ff2f6634cfbd04a) by classicalliu).
- Update readme for update note ([50d5e9b](https://github.com/citahub/re-birth/commit/50d5e9bc86d78a7f22dd05ac72915a774b8f24f9) by classicalliu).
- Update gems and fix it's problems ([e4c76fc](https://github.com/citahub/re-birth/commit/e4c76fcba11b10df956ca943d53c0a7cce127201) by classicalliu).
- Update readme for erc20 transfers ([181d2f3](https://github.com/citahub/re-birth/commit/181d2f3722ac1ff9faecf4b33db81f3018dde678) by classicalliu).
- Auto run code quality audit task on ci ([704b027](https://github.com/citahub/re-birth/commit/704b02780b332593ef8f13efd08c932eceae29f6) by RainChen).
- Set valueformat=decimal in transaction list ([d2c3d61](https://github.com/citahub/re-birth/commit/d2c3d61a3709f7c705c8ee1e84b8ab58c7495849) by classicalliu).
- Set root get path to 404 no found ([dd5d59f](https://github.com/citahub/re-birth/commit/dd5d59fe8de15a6a43a3a166ea1f1c3239bab9c8) by classicalliu).
- Update readme, add event log processor info ([3e7a155](https://github.com/citahub/re-birth/commit/3e7a1550fc3a68036ed00314c684eb04bf3c79f0) by classicalliu).
- Move upgrade 0.18 script from migration to rake task and note that in readme ([9d87f48](https://github.com/citahub/re-birth/commit/9d87f487381e6739fdb05eef8441d95aee7f901d) by classicalliu).
- Test event log processor ([3cad25b](https://github.com/citahub/re-birth/commit/3cad25bb65629923f7f0b8aa02001ae7f04f6da1) by classicalliu).
- Rename eventlogprocess to eventlogprocessor ([638246b](https://github.com/citahub/re-birth/commit/638246b02bd6036665acb55a7445f28ccf638731) by classicalliu).
- Cache validator counter ([91efc85](https://github.com/citahub/re-birth/commit/91efc8541bf6159d2e06bfd1108faa759f792b7c) by classicalliu).
- Create a contract event log by custom config ([879b492](https://github.com/citahub/re-birth/commit/879b49241491bd58398a45f3dab1c9897fac9d16) by classicalliu).
- Update readme ([0c4c914](https://github.com/citahub/re-birth/commit/0c4c91485fcb4a18d0af16a89d217aa46e64836a) by classicalliu).
- Ignore from and to case when get transactions ([1c794f6](https://github.com/citahub/re-birth/commit/1c794f6fad9a6a555a3f7a15d650a85c9fbc72c8) by classicalliu).
- Upgrade to work with cita v0.18 ([35b64da](https://github.com/citahub/re-birth/commit/35b64dab58cc3b6ee8951701d7b12ba512bb5ec0) by classicalliu).
- Replace appchain with appchain ([2c9d297](https://github.com/citahub/re-birth/commit/2c9d2975065d3f7db582e0620c6e47a919cdc5b3) by classicalliu).
- Update readme for db data path ([ca6fce6](https://github.com/citahub/re-birth/commit/ca6fce67cb9741ff68c7aa18296c054a7e8103a3) by classicalliu).
- Set docker app lang ([2b45e80](https://github.com/citahub/re-birth/commit/2b45e80beef42df91603c83182e14882c7f2bec0) by classicalliu).
- Replace credentials with secrets... ([4007801](https://github.com/citahub/re-birth/commit/40078016255d61b89f60ffaaddeeebd746b1504a) by classicalliu).
- Optional blocks ([b169240](https://github.com/citahub/re-birth/commit/b16924054f2f6eb3bb49f39c86a39d46a850d21e) by classicalliu).
- Update proposals algorithm ([cd190f0](https://github.com/citahub/re-birth/commit/cd190f0c59cd7c893e087b98a4f99a210f736525) by classicalliu).


## [v0.1.1](https://github.com/citahub/re-birth/releases/tag/v0.1.1) ([compare](https://github.com/citahub/re-birth/compare/v0.1.0...v0.1.1)) - 2018-08-16

### Added
- Add index to block header and body ([d4b0f08](https://github.com/citahub/re-birth/commit/d4b0f08dd99dbe12c37462111364d7fe9f11a5b2) by classicalliu).

### Fixed
- Fix pagination problem, be with only offset or limit provided ([7fd6310](https://github.com/citahub/re-birth/commit/7fd6310c771d09853ec15c5fe1662c6dece922bb) by classicalliu).
- Fix a bug: tendermint => tendermint ([dd8aa12](https://github.com/citahub/re-birth/commit/dd8aa1281eb7a58e1e135266e601552eef500d34) by classicalliu).

### Misc
- Proposals get validators from metadata ([339b821](https://github.com/citahub/re-birth/commit/339b821b08c494b1ee237acd7956131c922022c9) by classicalliu).
- Resort transactions in controller ([3e45a80](https://github.com/citahub/re-birth/commit/3e45a8046835b6188d1915cd9c4769297d80b215) by classicalliu).


## [v0.1.0](https://github.com/citahub/re-birth/releases/tag/v0.1.0) ([compare](https://github.com/citahub/re-birth/compare/1dc8f65bc320235c3230e53bf528bac309b5d992...v0.1.0)) - 2018-08-13

### Added
- Add yard doc icon to readme ([8d40dde](https://github.com/citahub/re-birth/commit/8d40ddeff52dd93de5fd83787fd3aa62dce81f2b) by classicalliu).
- Add not found handle ([bb019b7](https://github.com/citahub/re-birth/commit/bb019b7bee149a3e690a94ed850f8a1027bfb503) by classicalliu).
- Add data to sync errors ([c4ea95c](https://github.com/citahub/re-birth/commit/c4ea95c8170d6128c9c52a81dd1f5a73df3fcbd0) by classicalliu).
- Add sync errors controller ([f25d2b1](https://github.com/citahub/re-birth/commit/f25d2b14d7f320a8ba42ed94c4ed059d4fdf12f6) by classicalliu).
- Add sync error records ([972f530](https://github.com/citahub/re-birth/commit/972f53094cb17f9658a52393845f6e75d06f479a) by classicalliu).
- Add hex utils ([9b9ea8d](https://github.com/citahub/re-birth/commit/9b9ea8d9284e0c1fccd7b721a77402c4e08ea4f7) by classicalliu).
- Add status controller ([6ed8dec](https://github.com/citahub/re-birth/commit/6ed8dec1f5d92de4a64191db9fb3cc8dbac16ab8) by classicalliu).
- Add deploy script ([7ed11a5](https://github.com/citahub/re-birth/commit/7ed11a5a9d76c008301b53a5bca00104c5c74a0a) by classicalliu).
- Add cita sync module test ([eaa9724](https://github.com/citahub/re-birth/commit/eaa97240cb8835b25c795e279f116f5d4c57c7f9) by classicalliu).
- Add some comments ([b7a2097](https://github.com/citahub/re-birth/commit/b7a209792bfe729d28927ac3680ab2f1c3b26503) by classicalliu).
- Add comments to api and basic class ([7690b0b](https://github.com/citahub/re-birth/commit/7690b0bc4d43cea681fac82c725bb979a67cfcbb) by classicalliu).
- Add comments to message class ([826db33](https://github.com/citahub/re-birth/commit/826db335bf690080ad88da87cdc1598afd73386f) by classicalliu).
- Add yard for doc ([e7b3d83](https://github.com/citahub/re-birth/commit/e7b3d8336b05f88091ff49f137a8cfa1324bb7c3) by classicalliu).
- Add codecov icon ([50a3623](https://github.com/citahub/re-birth/commit/50a36234ee7d9461095bf4c989e42d366725c1cf) by classicalliu).
- Add codecov ([c0e44b2](https://github.com/citahub/re-birth/commit/c0e44b2f598325644983af48b20d27f6a838de17) by classicalliu).
- Add rspec test suites ([12de9f2](https://github.com/citahub/re-birth/commit/12de9f2d999e732c45a397a50c0fa851bbedcf8d) by classicalliu).
- Add statistics api ([87577d8](https://github.com/citahub/re-birth/commit/87577d8b2ceb53e3363d25a1374d8be0a374e01f) by classicalliu).
- Add transaction controller and add index action ([3ca6fc7](https://github.com/citahub/re-birth/commit/3ca6fc720e1458cec424522bcd73d941597c73bb) by classicalliu).
- Add offset and limit support to controller index action ([ad04b1c](https://github.com/citahub/re-birth/commit/ad04b1c6d73358c3254a75e3f489997103f41b56) by classicalliu).
- Add getblockbyhash to localinfocontroller ([bdc2d8e](https://github.com/citahub/re-birth/commit/bdc2d8e3529cccf513446157f73caa3e32518b1d) by classicalliu).
- Add more useful columns to transaction ([3f027ae](https://github.com/citahub/re-birth/commit/3f027aeb69b67c096cc1801f832f2e48c249f445) by classicalliu).
- Add message model to process transaction content and get original value ([4bcd15f](https://github.com/citahub/re-birth/commit/4bcd15fb5c87e7d0c956dc133d7a6f4deb542320) by classicalliu).
- Add transaction_count to block and add blocks controller ([f1f1b00](https://github.com/citahub/re-birth/commit/f1f1b008e66d335aaacf3e58dcd9eba0b2a566a3) by classicalliu).
- Add travis ci build status to readme ([0c8b25a](https://github.com/citahub/re-birth/commit/0c8b25aff0971127d1162a6481811c3ccc317dff) by classicalliu).
- Add cita api ([d5c9667](https://github.com/citahub/re-birth/commit/d5c96674e6d0d439dfee9a8e71d57034b99ddb9e) by classicalliu).
- Add abi model ([eb47751](https://github.com/citahub/re-birth/commit/eb477516794182d57018551b5c0e51edce75278d) by classicalliu).
- Add travis ci files ([66919c0](https://github.com/citahub/re-birth/commit/66919c0dc643d859443530a93196a8e1f86c0651) by classicalliu).
- Add balance model and fix a test bug ([8242e3f](https://github.com/citahub/re-birth/commit/8242e3fa8b237d74a3d28bd2d85bba97ac2ddb7d) by classicalliu).
- Add meta data model and persisted it ([30674d4](https://github.com/citahub/re-birth/commit/30674d459d346b700f589ed0c859745eb84d6284) by classicalliu).
- Add license ([03aa854](https://github.com/citahub/re-birth/commit/03aa8542092f8865ef99ae679a03ecaff448877f) by classicalliu).
- Add block and transaction model and sync them ([e3d2d31](https://github.com/citahub/re-birth/commit/e3d2d3121fb4994203430b4284dbf90c293a2734) by classicalliu).
- Add pry for console and awesome print ([975fc7b](https://github.com/citahub/re-birth/commit/975fc7b482c04f49674c44ed186fbd7155ab3fc3) by classicalliu).

### Changed
- Change nervos appchain link ([0bc3c4c](https://github.com/citahub/re-birth/commit/0bc3c4c477ff81e14ea9ac35e9ce69234a560834) by Mine77).

### Fixed
- Fix concern yard doc problem ([406280d](https://github.com/citahub/re-birth/commit/406280d62002f90edec629f2cadf8842f4cf92f6) by classicalliu).
- Fix license ([58a9739](https://github.com/citahub/re-birth/commit/58a9739d99bc8d64a354d554a254fbd3d82de430) by classicalliu).
- Fix ci ([2aa93cf](https://github.com/citahub/re-birth/commit/2aa93cf8c92417c010f1ae6f0925229a6d61d988) by classicalliu).
- Fix a bug ([e609c6e](https://github.com/citahub/re-birth/commit/e609c6ef330ec4fb9fdbe8121e9d79ab80dbd6b6) by classicalliu).
- Fix travis ci ([4c871f1](https://github.com/citahub/re-birth/commit/4c871f1776a820731505c1e929a81d471e904bcd) by classicalliu).

### Removed
- Remove test dir ([45a20cd](https://github.com/citahub/re-birth/commit/45a20cd2999ed0a4976a159393603ec949227984) by classicalliu).

### Misc
- Rename rebirth to re-birth ([9dbbdfb](https://github.com/citahub/re-birth/commit/9dbbdfb2535f6c5502b3d1b338a015e9287a366c) by classicalliu).
- Update readme.md (#5) ([2ba4f50](https://github.com/citahub/re-birth/commit/2ba4f509dac29c39ceef30c9f26a286935a13aef) by Mine77).
- Update readme for env set ([75dd4d6](https://github.com/citahub/re-birth/commit/75dd4d60cb64c203d7f47fc9e6f21b400c03c6d5) by classicalliu).
- Update: add bundle step to doc ([5432ff2](https://github.com/citahub/re-birth/commit/5432ff2eca46a1f187476afd7c1e0e911dafc781) by Keith).
- Update readme for secp256k1 install info ([41d1ca7](https://github.com/citahub/re-birth/commit/41d1ca720b8402a836ff554fb4629c063e331f1a) by classicalliu).
- Update readme for deploy and apidocs ([0f37829](https://github.com/citahub/re-birth/commit/0f378295a8180d47a2ded8db1ea01651ab4289ae) by classicalliu).
- Update persist comments ([2a17c4a](https://github.com/citahub/re-birth/commit/2a17c4a123c705b89f5ff49c232e3b5bc4e4edf1) by classicalliu).
- Make save_balance and save_abi return format concord ([590a223](https://github.com/citahub/re-birth/commit/590a2236f8a8e8fdd524a38b55e3b19b1504decd) by classicalliu).
- Rename basic to http and remove useless methods ([ceca7b4](https://github.com/citahub/re-birth/commit/ceca7b46296fc7640be98ca69a70265a7801860a) by classicalliu).
- Move local infos and split requests controllers to concerns ([d1692a4](https://github.com/citahub/re-birth/commit/d1692a48d159c09039a1aa138feb2925cb825aee) by classicalliu).
- Update codecov icon ([1ddd0f8](https://github.com/citahub/re-birth/commit/1ddd0f8096550d51bba6178d3264acd606e99ac0) by classicalliu).
- Update travis ci to support codecov ([fe37f00](https://github.com/citahub/re-birth/commit/fe37f00a7a7c46ea7f3df170330099b9b6a59737) by classicalliu).
- Update ci status icon ([70c6650](https://github.com/citahub/re-birth/commit/70c665012c9fd2240a0d9e0ec3d589c82296ad66) by classicalliu).
- Rename to rebirth ([02407fe](https://github.com/citahub/re-birth/commit/02407feb80be53502e5cbe51dd1a8a8ec1a98e6c) by classicalliu).
- Update ruby version to 2.5.1 ([0c52de5](https://github.com/citahub/re-birth/commit/0c52de5e6c9328040b2b326346c7a8c21905c444) by classicalliu).
- Test statistics controller ([984217c](https://github.com/citahub/re-birth/commit/984217c0c75ea5deb11d7c556317218b03e4e0d7) by classicalliu).
- Test transactions controller ([d5c6b06](https://github.com/citahub/re-birth/commit/d5c6b06cd13b94c9f0e3b73f2fa006730179705b) by classicalliu).
- Test blocks controller ([d6dc29a](https://github.com/citahub/re-birth/commit/d6dc29a98b6b9a0894ebdde6c29ac31778f513a2) by classicalliu).
- Test cita controller ([e5a7bc7](https://github.com/citahub/re-birth/commit/e5a7bc7fce8c6a7e07bb43b9a644a9dc46f863ca) by classicalliu).
- Test split request controller ([10ed0aa](https://github.com/citahub/re-birth/commit/10ed0aa214c0dc384e255a515cf7a67630b206b4) by classicalliu).
- Test local info controller ([c24c508](https://github.com/citahub/re-birth/commit/c24c50818aada5b94aa4ac12cf55c716471f7184) by classicalliu).
- Test message ([0280738](https://github.com/citahub/re-birth/commit/028073873aa1636143c7dbed578dddd0c78aa13a) by classicalliu).
- Update message get_from method algorithm ([7bb56d8](https://github.com/citahub/re-birth/commit/7bb56d8b1c51b468d771e6505994794e6139e92d) by classicalliu).
- Save block always with transactions ([d41c701](https://github.com/citahub/re-birth/commit/d41c701242f99639612957092caba4ee1d8af9b3) by classicalliu).
- Init issue templates ([d1df18f](https://github.com/citahub/re-birth/commit/d1df18ffffdf9d09d436f30b872a17b81b447d60) by classicalliu).
- Save address with lower case (abi & balance) ([8c9d020](https://github.com/citahub/re-birth/commit/8c9d0206597621726f0f74e1fe96bb870cd3b491) by classicalliu).
- Blocks api ([d9bad54](https://github.com/citahub/re-birth/commit/d9bad548a27cc66e635e87fac24a242e1d69210c) by classicalliu).
- Move controllers to root directory ([d1e4c9f](https://github.com/citahub/re-birth/commit/d1e4c9f6cca494a161a036d6fcab0abd6d5b69a8) by classicalliu).
- Cors support ([43e7af0](https://github.com/citahub/re-birth/commit/43e7af0e7aaef16b0f448eae6565f7d7057a5e51) by classicalliu).
- Sync process ([1cbd340](https://github.com/citahub/re-birth/commit/1cbd34018c723bcff8e4bbe9fceeddce36226f85) by classicalliu).
- Build rpc apis ([d75defd](https://github.com/citahub/re-birth/commit/d75defded398162497e07da5f1c4dfb13168bb0c) by classicalliu).
- Call_rpc method support id and jsonrpc ([288f73a](https://github.com/citahub/re-birth/commit/288f73ae236847a02c8504727562a54fb39eb161) by classicalliu).
- Save block with meta data ([9919425](https://github.com/citahub/re-birth/commit/9919425a43fce664ba87c7e8af5676d90224c6d2) by classicalliu).
- Save abi ([0b0b3e6](https://github.com/citahub/re-birth/commit/0b0b3e62d71a7c6b0d43402181453c2fd67852be) by classicalliu).
- Update ci config ([2687d29](https://github.com/citahub/re-birth/commit/2687d29d282a441982742e60f6c517678d5712bd) by classicalliu).
- Transfer keys methods ([d3eec43](https://github.com/citahub/re-birth/commit/d3eec43c82cb24287bc44f19307ac895c88c2123) by classicalliu).
- Wrapper stub request for rpc call ([0de818f](https://github.com/citahub/re-birth/commit/0de818fcd0200503ded344e7f96fc44e4d36c16e) by classicalliu).
- Update gems, for security problem (github notice) ([189df36](https://github.com/citahub/re-birth/commit/189df3691bc3c1f026aba304c6af79ea9241ca10) by classicalliu).
- Pass all tests (for cita rpc methods name changed) ([3fa595f](https://github.com/citahub/re-birth/commit/3fa595ff33e64324a9860caf510185b2c36633c5) by classicalliu).
- New api methods without prefix in cita 0.16 ([4829c4a](https://github.com/citahub/re-birth/commit/4829c4a3d30f0b6245cff249bef9f88436ee95cc) by classicalliu).
- Test cita sync api ([f8fece7](https://github.com/citahub/re-birth/commit/f8fece7bf6b2e0e79e5a5ae70e34103c987255d2) by classicalliu).
- Cita sync api methods ([5793798](https://github.com/citahub/re-birth/commit/57937985ba569011f14cdb2a08baace6c4699dc1) by classicalliu).
- Config env by dotenv ([f290efe](https://github.com/citahub/re-birth/commit/f290efee7f0745bada2f7d5dd11b1f31b89d250d) by classicalliu).
- Update readme ([dad0296](https://github.com/citahub/re-birth/commit/dad0296c576cbdacc886f12aaa1c38a96bef0a23) by classicalliu).
- Init project ([1dc8f65](https://github.com/citahub/re-birth/commit/1dc8f65bc320235c3230e53bf528bac309b5d992) by classicalliu).


