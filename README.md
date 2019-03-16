# trandom

trandom is a cross-platform Haxe library for accessing cryptographic secure numbers from the target's cryptographic random number generator.

## Supported targets

| Target | Source |
|--------|--------|
| CPP (C++) | See Sys. Windows: `RtlGenRandom` |
| CS (C#) | `cs.system.security.cryptography.RandomNumberGenerator` |
| Flash (SWF) | `flash.crypto.generateRandomBytes` |
| Hashlink |See Sys. Windows: `RtlGenRandom` |
| Java | `java.security.SecureRandom` |
| JS | HTML: `window.crypto`, Nodejs: `crypto.randomBytes` |
| Lua | See Sys. Windows: not implemented |
| Neko | See Sys. Windows: `RtlGenRandom` |
| PHP | `random_int` |
| Python | `os.urandom` |
| Sys | Any OS that provides `/dev/urandom`, `/dev/random` |

## Getting started

Requires:

* Haxe 4

### Install

Download and install the library using haxelib:

    haxelib install trandom

Or you may install it directly from GitHub:

    haxelib git https://github.com/chfoo/trandom

Or finally for the security minded, you may install from a ZIP file release after verifying its signature:

    haxelib install trandom-X.X.X-20YYmmdd-HHMMSS.zip

### Usage

trandom only provides one API method which the example below demonstrates:

```haxe
import trandom.TargetRandom;

class Main {
    public static function main() {
        var randomValue = TargetRandom.random();
        trace(randomValue); // => Int
    }
}
```

`randomValue` is a signed 32-bit integer. If there is no cryptographic source, an exception of type String is thrown by trandom or any other exception type by the underlying target.

## Platform notes

### Windows

Add a Haxe define `-D trandom_windows` to the Haxe compiler config. This define will enable the call to RtlGenRandom for targets that don't provide a builtin API to a cryptographic source. It uses the target's foreign function interface system to bind with trandom's native C code.

#### Hashlink

The hdll library `trandom.hdll` needs to be included with your application. A prebuilt library is included in the release ZIP file.

To build it manually using MinGW-w64:

    i686-w64-mingw32-gcc.exe -O -D LIBHL_EXPORTS -fPIC -shared -std=c11 -o trandom.hdll trandom_native.c -I hl-1.9.0-win/include

Adjust paths in the command as needed.

#### Neko

The hdll library `trandom.hdll` needs to be included with your application. A prebuilt library is included in the release ZIP file.

To build it manually using MinGW-w64:

    i686-w64-mingw32-gcc.exe -O -D NEKOVM_DLL_EXPORTS -fPIC -shared -std=c11 -o trandom.hdll trandom_native.c -I $NEKO_INSTPATH/include -L $NEKO_INSTPATH -lneko

Adjust paths in the command as needed.

#### CPP - MinGW-w64 (Optional)

If you are having trouble getting hxcpp to use Visual Studio for compilation, you can use MingGW-w64.

To enable compilation by MinGW, add this to `%HOMEPATH%/.hxcpp_config.xml` under the "VARS" section:

    <set name="mingw" value="1" />

If needed, add the path to MinGW-w64:

    <set name="MINGW_ROOT" value="C:\Program Files (x86)\mingw-w64\i686-8.1.0-posix-dwarf-rt_v6-rev0\mingw32" />

### Flash

Use `-swf-version 11` or greater version number in your Haxe compiler config to access the Flash crypto package API. The default is 10.0. At the time of writing, the current version is 43.

## Considerations

* Don't fallback to using `Math.random` or `Sys.random` for cryptographic purposes
* If used in a virtual machine with snapshots, the returned values may be the same
* The quality of randomness is determined by the target or platform

## Contributing

If you have a bug report or issue, please file an issue. If you would like to fix a bug or implement support for more platforms/targets, please make a pull request.
