package net.noiseinstitute.basecode {
    import net.flashpunk.FP;

    /** Trigonometric functions operating operating on the same strange
     * 'negative degrees' units as used by FlashPunk (i.e. -90 represents a
     * clockwise quarter-turn). */
    public class Trig {
        /** Trigonometric sine function operating on the same strange 'negative
         * degrees' units as used by FlashPunk (i.e. -90 represents a clockwise
         * quarter-turn).
         * @param angle The angle in negative degrees.
         * @return sin(angle) for the given angle. */
        public static function sin(angle:Number):Number {
            return Math.sin(angle*FP.RAD);
        }

        /** Trigonometric cosine function operating on the same strange 'negative
         * degrees' units as used by FlashPunk (i.e. -90 represents a clockwise
         * quarter-turn).
         * @param angle The angle in negative degrees.
         * @return cos(angle) for the given angle. */
        public static function cos(angle:Number):Number {
            return Math.cos(angle*FP.RAD);
        }
    }
}
