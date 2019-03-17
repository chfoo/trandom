package trandom;

import haxe.macro.Compiler;
import haxe.macro.Context;

class InitMacro {
    public static function checkWindows() {
        if (!Context.defined("trandom_no_auto_ffi") && Sys.systemName() == "Windows") {
            Compiler.define("trandom_windows");
        }
    }
}
