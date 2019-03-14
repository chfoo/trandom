package trandom.test;

import utest.Assert;
import utest.Test;

class TestRandom extends Test {
    public function testByte() {
        var randomInt = TargetRandom.random();

        trace(randomInt);

        var part1 = (randomInt >> 24) & 0xff;
        var part2 = (randomInt >> 16) & 0xff;
        var part3 = (randomInt >> 8) & 0xff;
        var part4 = randomInt & 0xff;

        Assert.notEquals(part1, part2);
        Assert.notEquals(part1, part3);
        Assert.notEquals(part1, part4);
    }

    public function testInt() {
        var randomInt1 = TargetRandom.random();
        var randomInt2 = TargetRandom.random();

        trace('$randomInt1 $randomInt2');

        Assert.notEquals(randomInt1, randomInt2);
    }

}
