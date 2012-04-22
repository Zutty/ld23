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
    
    import uk.co.zutty.ld23.GameWorld;
    import uk.co.zutty.ld23.Main;
    import uk.co.zutty.ld23.game.Party;
    import uk.co.zutty.ld23.game.Poll;
    import uk.co.zutty.ld23.game.Tribe;
    
    public class Voter extends Entity {

        [Embed(source = 'voters.png')]
        private static const VOTERS_IMAGE:Class;
        
        [Embed(source = 'icons.png')]
        private static const ICONS_IMAGE:Class;

        private static const SPEED:Number = 0.8;
        private static const INTERACT_RANGE:Number = 60; 
        private static const INTERCEPT_RANGE:Number = 220;
        private static const TALK_TIME:uint = 40;
        private static const TALK_TIME_VARIANCE:uint = 20;
        
        public static const STATE_IDLE:int = 1;
        public static const STATE_WANDER:int = 2;
        public static const STATE_INTERCEPT:int = 3;
        public static const STATE_CONVERSE_READY:int = 4;
        public static const STATE_CONVERSE_TALK:int = 5;
        public static const STATE_CONVERSE_LISTEN:int = 6;
        
        private var _spritemap:Spritemap;
        private var _bubble:Spritemap;
        private var _type:int;
        private var _move:Point;
        
        private var _waypoint:Point;
        private var _target:Entity;
        
        private var _tribe:Tribe;
        private var _state:int;
        private var _timer:uint;
        private var _conversationLength:int;

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
            _bubble.add("question", [2]);
            _bubble.centerOrigin();
            _bubble.y -= 30;
            _bubble.play("question");
            _bubble.visible = false;
            addGraphic(_bubble);
            
            _type = type;
            _spritemap.play("type"+_type+"_stand");
            
            // HACK!
            _spritemap.tintMode = 1;//Image.TINTING_COLORIZE;
            _spritemap.tinting = -.8;
            
            this.type = "mob";
            
            _waypoint = null;
            _target = null;
            _move = new Point(0, 0);
            _conversationLength = 0;
            idle();
        }
        
        private function addAnimRow(type:int):void {
            var off:int = (type - 1) * 7; 
            _spritemap.add("type"+type+"_stand", [off + 0]);
            _spritemap.add("type"+type+"_walk", [off + 1, off + 2, off + 3, off + 4], 12, true);
            _spritemap.add("type"+type+"_talk", [off + 5, off + 6], 8, true);
        }
        
        public function get state():int {
            return _state;
        }
        
        public function set tintColour(colour:uint):void {
            _spritemap.color = ~colour;
        }
        
        public function wander():void {
            var p:Point = VectorMath.polar(FP.rand(360), FP.rand(200) + 100);
            p.x += _tribe.hut.x;
            p.y += _tribe.hut.y;
            moveToPoint(p);
            _state = STATE_WANDER;
        }
        
        public function idle():void {
            stop();
            _state = STATE_IDLE;
        }
        
        public function intercept():void {
            _target = findTarget();
            _state = STATE_INTERCEPT;
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
        
        public function talkTo(_target:Voter):void {
            // Target yields control to this voter
            speak();
            _target.listen();
            _conversationLength--;
        }
            
        public function speak():void {
            _state = STATE_CONVERSE_TALK;
            _move.x = 0;
            _move.y = 0;
            _spritemap.play("type"+_type+"_talk");
            _bubble.visible = true;
            _timer = TALK_TIME + FP.rand(TALK_TIME_VARIANCE);
        }
        
        public function listen():void {
            stop();
            _state = STATE_CONVERSE_LISTEN;
            _bubble.visible = false;
        }

        public function stopTalking():void {
            idle();
            type = "mob";
            (_target as Voter).idle();
            _target.type = "mob";
            _bubble.visible = false;
        }

        public function get isConversing():Boolean {
            return (_state == STATE_CONVERSE_TALK || _state == STATE_CONVERSE_LISTEN) && _target != null;
        }
        
        public function converseInterrupt():Boolean {
            if(_state == STATE_IDLE || _state == STATE_WANDER) {
                _state = STATE_CONVERSE_READY;
                type = "mob_talk";
            }
            return _state == STATE_CONVERSE_READY;
        }
        
        public function vote(poll:Poll):Party {
            return FP.choose(poll.parties);
        }
        
        override public function update():void {
            super.update();
            
            // Decrement timer
            if(_timer > 0) {
                _timer--;
            }
            
            // If wandering, move towards waypoint
            if(_state == STATE_WANDER && _waypoint) {
                FP.point.x = _waypoint.x - x;
                FP.point.y = _waypoint.y - y;

                if(VectorMath.magnitude(FP.point) <= SPEED) {
                    _waypoint = null;
                    idle();
                } else {
                    move(VectorMath.angle(FP.point));
                }
            }
            
            // If intercepting, move towards target
            if(_state == STATE_INTERCEPT) {
                if(_target == null || distanceFrom(_target) > INTERCEPT_RANGE) {
                    // If target moves out of range, then go back to idle
                    idle();
                } else if(distanceFrom(_target) <= INTERACT_RANGE) {
                    stop();
                    
                    if(_target is Voter) {
                        var voter:Voter = _target as Voter; 

                        // If target moves into interaction range and is another voter, then prepare to start talking
                        if(voter.converseInterrupt()) {
                            type = "mob_talk";
                            _conversationLength = 2+FP.rand(2);
                            voter._target = this;
                            talkTo(voter);
                        } else {
                            idle();
                        }
                    }
                } else if(distanceFrom(_target) > INTERACT_RANGE) {
                    // Otherwise, move towards the target
                    FP.point.x = _target.x - x;
                    FP.point.y = _target.y - y;
                    move(VectorMath.angle(FP.point));
                }
            }
            
            // If finished talking, pass to other
            if(_state == STATE_CONVERSE_TALK && _target && _timer == 0) {
                if(_conversationLength == 0) {
                    stopTalking();
                } else {
                    (_target as Voter).talkTo(this);
                }
            }
            
            // If doing nothing, decide on something to do.
            if(_state == STATE_IDLE) {
                if(Math.random() < 0.05 && findTarget()) {
                    intercept();
                } else if(Math.random() < 0.1) {
                    // Wander again!
                    wander();
                }
            }
            
            // Move
            x += _move.x;
            y += _move.y;
            
            layer = -y - 24;
        }

        /**
         *  Resolve a target, and return true if one has been aquired.
         */
        private function findTarget():Entity {
            if(Main.gameworld == null) {
                return null;
            }
            
            var target:Entity = Main.gameworld.nearestToEntity("mob", this);
            var valid:Boolean = target != null && distanceFrom(target) <= INTERCEPT_RANGE;
            return valid ? target : null;
        }
        
        private function isBusy(e:Entity):Boolean {
            return _target is Voter && ((_target as Voter).isConversing || (_target as Voter).state == STATE_CONVERSE_READY);
        }
    }
}