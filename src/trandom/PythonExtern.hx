package trandom;

@:pythonImport("os")
extern class PythonExtern {
    static function urandom(count:Int):python.Bytes;
}
