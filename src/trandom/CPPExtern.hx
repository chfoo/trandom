package trandom;

@:include("trandom_native.c")

#if (haxelib || trandom)
@:buildXml("<include name=\"${haxelib:trandom}/native/hxcpp_build.xml\" />")
#else
// `this_dir` is out/cpp/
@:buildXml("<include name=\"${this_dir}/../../native/hxcpp_build.xml\" />")
#end

extern class CPPExtern {
    @:native("trandom_get")
    static function get(output:cpp.RawPointer<Int>):Int;
}
