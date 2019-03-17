package trandom;

class TargetRandom {
    /**
     * Returns a signed 32-bit integer from the target's cryptographic secure random number generator.
     *
     * If there is no secure source, a String exception is thrown. Other exceptions may be thrown by the underlying target.
     *
     * Depending on the operating system, this method may block for a long period of time until there is sufficient entropy.
     */
    public static function random():Int {
        return trandom.Native.get();
    }
}
