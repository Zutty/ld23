package uk.co.zutty.ld23.entity
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.noiseinstitute.basecode.VectorMath;
    
    import uk.co.zutty.ld23.game.Party;
    import uk.co.zutty.ld23.game.Poll;
    
    public class Voter extends Entity {

        [Embed(source = 'voters.png')]
        private static const VOTERS_IMAGE:Class;
        
        private static const SPEED:Number = 0.8;
        
        private var _spritemap:Spritemap;
        private var _type:int;
        private var _move:Point;

        public function Voter(type:int = 1) {
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
            _spritemap.centerOrigin()
            graphic = _spritemap;
            
            _type = type;
            _spritemap.play("type"+_type+"_stand");
            
            // HACK!
            _spritemap.tintMode = 1;//Image.TINTING_COLORIZE;
            _spritemap.tinting = -.8;
            
            _move = new Point(0, 0);
        }
        
        public function set tintColour(colour:uint):void {
            _spritemap.color = ~colour;
        }
        
        public function move(direction:Number):void {
            VectorMath.becomePolar(_move, direction, SPEED); 
            if(_move.x == 0 && _move.y == 0) {
                _spritemap.play("type"+_type+"_stand");
            } else {
                _spritemap.play("type"+_type+"_walk");
                _spritemap.flipped = _move.x >= 0;
            }
        }
        
        public function vote(poll:Poll):Party {
            return FP.choose(poll.parties);
        }
        
        override public function update():void {
            super.update();
            
            x += _move.x;
            y += _move.y;
            
            layer = -y - 24;
        }
    }
}