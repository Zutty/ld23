package uk.co.zutty.ld23
{
    import flash.geom.Point;
    
    public class Waypoint extends Point {
        
        private var _parent:Waypoint;
        
        public function Waypoint(x:Number=0, y:Number=0, parent:Waypoint = null) {
            super(x, y);
            _parent = parent;
        }
        
        public function get parent():Waypoint {
            return _parent;
        }
    }
}