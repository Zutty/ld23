package uk.co.zutty.ld23.entity
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
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
        
        [Embed(source = 'icons.png')]
        private static const ICONS_IMAGE:Class;

        private static const SPEED:Number = 0.8;
        
        private var _spritemap:Spritemap;
        private var _bubble:Spritemap;
        private var _type:int;
        private var _move:Point;
        private var _waypoint:Point;
        private var _tribe:Tribe;

        public function Voter(tribe:Tribe, type:int = 1) {
            super();
            
            _tribe = tribe;
            _tribe.addVoter(this);
            
            _spritemap = new Spritemap(VOTERS_IMAGE, 48, 48);
            for(var n:int = 1; n <= 4; n++) {
                addAnimRow(n);
            }
            _spritemap.centerOrigin()
            addGraphic(_spritemap);
            
            _bubble = new Spritemap(ICONS_IMAGE, 24, 24);
            _bubble.add("member", [0]);
            _bubble.add("question", [1]);
            _bubble.centerOrigin();
            _bubble.y -= 30;
            _bubble.play("question");
            //_bubble.visible = false;
            addGraphic(_bubble);
            
            _type = type;
            _spritemap.play("type"+_type+"_stand");
            
            // HACK!
            _spritemap.tintMode = 1;//Image.TINTING_COLORIZE;
            _spritemap.tinting = -.8;
            
            _waypoint = null;
            _move = new Point(0, 0);
        }
        
        private function addAnimRow(type:int):void {
            var off:int = (type - 1) * 7; 
            _spritemap.add("type"+type+"_stand", [off + 0]);
            _spritemap.add("type"+type+"_walk", [off + 1, off + 2, off + 3, off + 4], 12, true);
            _spritemap.add("type"+type+"_talk", [off + 5, off + 6], 8, true);
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
            } else if(Math.random() < 0.01) {
                wander();
            }
            
            x += _move.x;
            y += _move.y;
            
            layer = -y - 24;
        }
    }
}