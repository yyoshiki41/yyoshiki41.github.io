## Mac OSX

```bash
$ bundle install
$ bundle exec jekyll serve --watch
```

## Docker

### Dev

```bash
$ docker run --rm -it -p 4000:4000 -v `pwd`:/app yyoshiki41/jekyll:1.0 bash -c "bundle install; bundle exec jekyll serve --watch --incremental --force_polling -H 0.0.0.0"
```

or

```bash
$ docker build -t yyoshiki41/jekyll ./
$ docker run --rm -it -p 4000:4000 -v `pwd`:/app yyoshiki41/jekyll:1.0
```
