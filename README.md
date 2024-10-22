# Python 2 Project with Google Datastore on NixOS

## Setup

- On NixOS, ensure your system has the following:
```nix
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];
};
```
- Clone repo, change into directory.
- If you don't have direnv, run the command `nix develop` to activate the development flake.
- Run `./bin/install.sh`
- Run `./bin/start.sh`
- Observe error:
```
ImportError: libstdc++.so.6: cannot open shared object file: No such file or directory
```
- In `flake.nix`, uncomment this line:
```
LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
```
- Run `./bin/start.sh`
- Observe different error:
```
python: /nix/store/a6rnjp15qgp8a699dlffqj94hzy1nldg-glibc-2.32/lib/libc.so.6: version `GLIBC_2.35' not found (required by /nix/store/y3kdn61k93rq2jx1lj2x72lnsk0l92qh-gcc-13.3.0-lib/lib/libgcc_s.so.1)
python: /nix/store/a6rnjp15qgp8a699dlffqj94hzy1nldg-glibc-2.32/lib/libc.so.6: version `GLIBC_2.34' not found (required by /nix/store/y3kdn61k93rq2jx1lj2x72lnsk0l92qh-gcc-13.3.0-lib/lib/libgcc_s.so.1)
```

