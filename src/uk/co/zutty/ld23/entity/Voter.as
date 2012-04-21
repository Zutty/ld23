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
    import uk.co.zutty.ld23.game.Tribe;
    
    public class Voter extends Entity {

        [Embed(source = 'voters.png')]
        private static const VOTERS_IMAGE:Class;
        
        private static const SPEED:Number = 0.8;
        
        private var _spritemap:Spritemap;
        private var _type:int;
        private var _move:Point;
        private var _waypoint:Point;
        private var _tribe:Tribe;

        public function Voter(tribe:Tribe, type:int = 1) {
            super();
            
            _tribe = tribe;
            _tribe.addVoter(this);
            
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
            
            _waypoint = null;
            _move = new Point(0, 0);
        }
        
        public function set tintColour(colour:uint):void {
            _spritemap.color = ~colour;
        }
        
        public function wander():void {
            var p:Point = VectorMath.polar(FP.rand(360), FP.rand(200) + 100);
            p.x += _tribe.hut.x;
            p.y += _tribe.hut.y;
            moveToPoint(p);
        }
        
        public function moveToPoint(waypoint:Point):void {
            _waypoint = waypoint;
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
        
        public function stop():void {
            _move.x = 0;
            _move.y = 0;
            _spritemap.play("type"+_type+"_stand");
        }
        
        public function vote(poll:Poll):Party {
            return FP.choose(poll.parties);
        }
        
        override public function update():void {
            super.update();
            
            if(_waypoint) {
                FP.point.x = _waypoint.x - x;
                FP.point.y = _waypoint.y - y;

                if(VectorMath.magnitude(FP.point) <= SPEED) {
                    _waypoint = null;
                    stop();
                } else {
                    move(VectorMath.angle(FP.point));
                }
            } else if(Math.random() < 0.05) {
                wander();
            }
            
            x += _move.x;
            y += _move.y;
            
            layer = -y - 24;
        }
    }
}