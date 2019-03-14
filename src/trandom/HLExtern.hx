package trandom;

extern class HLExtern {
    @:hlNative("trandom", "trandom_get")
    static function get(output:hl.Ref<Int>):Int;
}
