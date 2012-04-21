package uk.co.zutty.ld23.entity
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Spritemap;
    
    public class Voter extends Entity {

        [Embed(source = 'voters.png')]
        private static const VOTERS_IMAGE:Class;
        
        private var _spritemap:Spritemap;

        public function Voter() {
            super();
            
            _spritemap = new Spritemap(VOTERS_IMAGE, 48, 48);
            _spritemap.add("type1_stand", [0]);
            _spritemap.add("type1_walk", [1,2,3,4], 12, true);
            _spritemap.add("type2_stand", [5]);
            _spritemap.add("type2_walk", [6,7,8,9], 12, true);
            _spritemap.add("type3_stand", [10]);
            _spritemap.add("type3_walk", [11,12,13,14], 12, true);
            _spritemap.add("type4_stand", [15]);
            _spritemap.add("type4_walk", [16,17,18,19], 12, true);
            graphic = _spritemap;
            
            _spritemap.play("type4_walk");
            _spritemap.flipped = true;
        }
        
        override public function update():void {
            super.update();
            
            x++;
        }
    }
}