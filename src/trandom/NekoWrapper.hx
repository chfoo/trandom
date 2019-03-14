package trandom;

class NekoWrapper {
    public static function get():Int {
        return _get();
    }

    static var _get = neko.Lib.load("trandom", "trandom_get_neko", 0);
}
