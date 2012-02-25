package net.noiseinstitute.basecode {
    public class Range {
        public static function wrap(n:Number, min:Number, max:Number):Number {
            if (n < min || n > max) {
                n -= min;
                max = max - min + 1;
                if (n < 0) {
                    n += max * Math.ceil(-n/max);
                }
                return min + n%max;
            } else {
                return n;
            }
        }

        public static function wrapAngle(n:Number):Number {
            return wrap(n, -180, 180);
        }

        public static function clip(n:Number, min:Number, max:Number):Number {
            if (n > max) return max;
            if (n < min) return min;
            return n;
        }
    }
}
