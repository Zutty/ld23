package net.noiseinstitute.basecode {
    import flash.geom.Point;

    import net.flashpunk.FP;

    public class VectorMath {
        public static function add(v:Point, w:Point):Point {
            return new Point(v.x+w.x, v.y+w.y);
        }

        public static function addTo(v:Point, w:Point):void {
            v.x += w.x;
            v.y += w.y;
        }

        public static function subtract(v:Point, w:Point):Point {
            return new Point(v.x-w.x, v.y-w.y);
        }

        public static function subtractFrom(v:Point, w:Point):void {
            v.x -= w.x;
            v.y -= w.y;
        }

        public static function dot(v:Point, w:Point):Number {
            return v.x*w.x + v.y*w.y;
        }

        public static function cross(v:Point, w:Point):Number {
            return v.x*w.y - v.y*w.x;
        }

        public static function scale(v:Point, s:Number):Point {
            return new Point(v.x * s, v.y * s);
        }

        public static function scaleInPlace(v:Point, s:Number):void {
            v.x *= s;
            v.y *= s;
        }

        public static function negate(v:Point):Point {
            return new Point(-v.x, -v.y);
        }

        public static function negateInPlace(v:Point):void {
            v.x = -v.x;
            v.y = -v.y;
        }

        public static function angle(v:Point):Number {
            return Math.atan2(v.x, -v.y) * FP.DEG;
        }

        public static function magnitude(v:Point):Number {
            return Math.sqrt(v.x*v.x + v.y*v.y);
        }

        public static function normalize(v:Point):Point {
            var m:Number = magnitude(v);
            if (m == 0) {
                return new Point(0, 0);
            } else {
                return new Point(v.x/m, v.y/m);
            }
        }

        public static function normalizeInPlace(v:Point):void {
            if (v.x != 0 || v.y != 0) {
                var m:Number = magnitude(v);
                v.x /= m;
                v.y /= m;
            }
        }

        public static function distance(v:Point, w:Point):Number {
            return Point.distance(v, w);
        }

        public static function rotate(v:Point, angle:Number):Point {
            var sin:Number = Trig.sin(angle);
            var cos:Number = Trig.cos(angle);
            return new Point(cos*v.x - sin*v.y,
                    cos*v.y + sin*v.x);
        }

        public static function rotateInPlace(v:Point, angle:Number):void {
            var sin:Number = Trig.sin(angle);
            var cos:Number = Trig.cos(angle);
            var oldX:Number = v.x;
            v.x = cos*v.x - sin*v.y;
            v.y = cos*v.y + sin*oldX;
        }

        public static function unitVector(angle:Number):Point {
            return new Point(Trig.sin(angle), -Trig.cos(angle));
        }

        public static function becomeUnitVector(v:Point, angle:Number):void {
            v.x = Trig.sin(angle);
            v.y = -Trig.cos(angle);
        }

        public static function polar(angle:Number, magnitude:Number):Point {
            return new Point(Trig.sin(angle)*magnitude, -Trig.cos(angle)*magnitude);
        }

        public static function becomePolar(v:Point, angle:Number, magnitude:Number):void {
            v.x = Trig.sin(angle)*magnitude;
            v.y = -Trig.cos(angle)*magnitude;
        }
        
        public static function set(p:Point, x:Number, y:Number):void {
            p.x = x;
            p.y = y;
        }
        
        public static function copyTo(p:Point, q:Point):void {
            p.x = q.x;
            p.y = q.y;
        }
    }
}
