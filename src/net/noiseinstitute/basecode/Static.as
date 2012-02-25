package net.noiseinstitute.basecode {
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /** Various statically allocated resources, to reduce garbage collection.
     * Don't expect any of these to retain their value across function calls! */
    public class Static {
        public static const point:Point = new Point();
        public static const point2:Point = new Point();
        public static const rect:Rectangle = new Rectangle();
        public static const matrix:Matrix = new Matrix();
    }
}
