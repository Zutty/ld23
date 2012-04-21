package uk.co.zutty.ld23.game
{
    import net.flashpunk.FP;
    
    import uk.co.zutty.ld23.entity.HutPart;

    public class Hut {
        
        private static const DEFAULT_COLOUR:uint = 0xaaaaaa;
        
        private var _roof:HutPart;
        private var _floor:HutPart;
        
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