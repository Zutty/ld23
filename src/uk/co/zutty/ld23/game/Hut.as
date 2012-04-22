package uk.co.zutty.ld23.game
{
    import flash.geom.Point;
    
    import net.flashpunk.FP;
    
    import uk.co.zutty.ld23.Waypoint;
    import uk.co.zutty.ld23.entity.HutPart;

    public class Hut {
        
        private static const DEFAULT_COLOUR:uint = 0xaaaaaa;
        
        private var _roof:HutPart;
        private var _floor:HutPart;
        private var _entryPoints:Array;
        private var _exitPoint:Waypoint;
        
        public function Hut(x:Number, y:Number) {
            var flip:Boolean = Math.random() > 0.5;
            _roof = new HutPart(HutPart.PART_ROOF, flip);
            _roof.tintColour = DEFAULT_COLOUR;
            _roof.x = x;
            _roof.y = y;
            _floor = new HutPart(HutPart.PART_FLOOR, flip);
            _floor.tintColour = DEFAULT_COLOUR;
            _floor.x = x;
            _floor.y = y;
            
            _exitPoint = new Waypoint(x+20, y-10, new Waypoint(x + 64, y + 64));

            var entry:Waypoint = new Waypoint(x + 64, y + 64, new Waypoint(x+20, y-10));
            var bl:Waypoint = new Waypoint(x - 90, y + 90, entry);
            var br:Waypoint = new Waypoint(x + 90, y + 90, entry);
            var tl:Waypoint = new Waypoint(x - 90, y - 90, bl);
            var tr:Waypoint = new Waypoint(x + 90, y - 90, br);
            _entryPoints = [entry, bl, br, tl, tr];
        }
        
        public function get entryPoints():Array {
            return _entryPoints;
        }
        
        public function get exitPoint():Waypoint {
            return _exitPoint;
        }

        public function get x():Number {
            return _roof.x;
        }

        public function get y():Number {
            return _roof.y;
        }

        public function set tintColour(colour:uint):void {
            _roof.tintColour = colour;
            _floor.tintColour = colour;
        }
        
        public function get roof():HutPart {
            return _roof;
        }

        public function get floor():HutPart {
            return _floor;
        }
    }
}