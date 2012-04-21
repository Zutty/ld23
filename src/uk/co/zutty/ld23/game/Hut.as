package uk.co.zutty.ld23.game
{
    import uk.co.zutty.ld23.entity.HutPart;

    public class Hut {
        
        private static const DEFAULT_COLOUR:uint = 0xaaaaaa;
        
        private var _roof:HutPart;
        private var _floor:HutPart;
        
        public function Hut(x:Number, y:Number) {
            _roof = new HutPart(HutPart.PART_ROOF);
            _roof.tintColour = DEFAULT_COLOUR;
            _roof.x = x;
            _roof.y = y;
            _floor = new HutPart(HutPart.PART_FLOOR);
            _floor.tintColour = DEFAULT_COLOUR;
            _floor.x = x;
            _floor.y = y;
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