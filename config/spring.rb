%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/utils/**
].each { |path| Spring.watch(path) }
