package trandom;

class TargetRandom {
    /**
     * Returns a signed 32-bit integer from the target's cryptographic secure random number generator.
     *
     * If there is no secure source, a String exception is thrown.
     */
    public static function random():Int {
        return trandom.Native.get();
    }
}
