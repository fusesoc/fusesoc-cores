FuseSoC standard core library
=============================

This is the standard core library to be used with [FuseSoC](https://github.com/olofk/fusesoc)

### Installation

This library will be automatically cloned to `~/.local/share/fusesoc/fusesoc-cores`
and added to `fusesoc.conf` when you run `fusesoc init`.

If you have a existing FuseSoC setup and the above does not work for you,
please consider this alternative installation method.  Use git to clone
this repository and add it to your `fusesoc.conf`.  For example in
`~/.config/fusesoc/fusesoc.conf`:

```
[main]
cores_root =
 /home/joe/work/fusesoc-cores
cache_root = /home/joe/work/fuse-cache
build_root = /home/joe/work/fuse-builds
```

### Contributing

Cores for FuseSoC should follow the following guidelines.

 - **No Code** Please do not store code in `fusesoc-cores`.  Please store
   your code in a separate repo or somewhere it can be fetched with the
   `url` provider.
 - If your core is really small please consider storing in the
   [tiny-cores](http://github.com/fusesoc/tiny-cores) repo.
 - **Stay Modern** Use the modern sections in your core file like `fileset`
   and `parameter`, please no obsolete `verilog` sections.  For details on
   migrating old cores to the current standard please refer to the
   [FuseSoC migration guide](https://github.com/olofk/fusesoc/blob/master/doc/migrations.adoc).
 - **Versioning** Each core should be versioned with either
   - **Versioned** For cores where the upstream provider provides a release
     version, in git using tags is ideal, please use the corresponding
     release version.
   - **Pseudo-versioned** When an core's upstream provider is out of your
     control and does not use versions please use version `0` and point to
     a location which is unique for that revision (e.g. the sha for git
     repos or revision for svn repos instead of pointing to master, which
     might change over time).  If you need to refer to a newer version of
     the upstream repo, still without a proper version, step the revision
     number (`0-r1`, `0-r2`..etc).
