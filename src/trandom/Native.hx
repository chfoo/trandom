package trandom;

import haxe.ds.Option;

typedef ArrayBuffer =
#if cs
    cs.NativeArray<cs.types.UInt8>
#else
    Dynamic
#end
;

class Native {
    static inline var DEV_URANDOM = "/dev/urandom";
    static inline var DEV_RANDOM = "/dev/random";

    static var isInitialized = false;

    #if cs
    static var rng:cs.system.security.cryptography.RandomNumberGenerator;
    #elseif java
    static var rng:java.security.SecureRandom;
    #end

    static function init() {
        #if cs
        rng = cs.system.security.cryptography.RandomNumberGenerator.Create();
        #elseif java
        rng = new java.security.SecureRandom();
        #end
    }

    public static function get():Int {
        if (!isInitialized) {
            init();
            isInitialized = true;
        }

        #if cs
        var buffer = new cs.NativeArray<cs.types.UInt8>(4);
        rng.GetBytes(buffer);
        return arrayToInt(buffer);

        #elseif java
        return rng.nextInt();

        #elseif js
        return getJS();

        #elseif php
        return php.Syntax.code("random_int({0}, {1})", -2147483648, 2147483647);

        #elseif python
        return arrayToInt(PythonExtern.urandom(4));

        #elseif sys
        return getSys();
        #end

        throw "Not implemented on this target";
    }

    #if sys
    static function getSys():Int {
        if (sys.FileSystem.exists(DEV_URANDOM)) {
            return readFile(DEV_URANDOM);
        } else if (sys.FileSystem.exists(DEV_RANDOM)) {
            return readFile(DEV_RANDOM);
        }

        #if trandom_windows
        switch getWindows() {
            case Some(value):
                return value;
            case None:
                // pass
        }
        #end

        throw "Random source not available.";
    }

    static function readFile(path:String):Int {
        var file = sys.io.File.read(path);
        var randomInt = file.readInt32();
        file.close();
        return randomInt;
    }
    #end

    #if trandom_windows
    static function getWindows():Option<Int> {
        #if cpp
        var output:Int = 0;
        var errorCode = CPPExtern.get(cpp.RawPointer.addressOf(output));
        if (errorCode == 0) {
            return Some(output);
        }
        #elseif hl
        var output:Int = 0;
        var errorCode = HLExtern.get(new hl.Ref(output));
        if (errorCode == 0) {
            return Some(output);
        }
        #elseif neko
        return Some(NekoWrapper.get());
        #else
            throw "Not implemented on this Windows target";
        #end

        return None;
    }
    #end

    #if js
    static function getJS():Int {
        if (js.Syntax.typeof(js.Browser.window) != "undefined") {
            var buffer = new js.html.Int32Array(1);
            js.Browser.window.crypto.getRandomValues(buffer);
            return buffer[0];

        } else if (js.Syntax.typeof(untyped __js__("require")) != "undefined") {
            var crypto = untyped __js__("require('crypto')");
            var buffer = crypto.randomBytes(4);
            return arrayToInt(buffer);

        } else {
            throw "Random source not available.";
        }
    }
    #end

    static function arrayToInt(array:ArrayBuffer):Int {
        return (array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3];
    }
}