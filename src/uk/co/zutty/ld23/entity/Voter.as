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
    import uk.co.zutty.ld23.Waypoint;
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
        public static const STATE_ENTER_HUT:int = 7;
        public static const STATE_EXIT_HUT:int = 8;
        
        private static const CONVERSATION_IDLE:Array = ["question", "weather", "plant", "hut"];
        private static const CONVERSATION_POLITICAL:Array = ["politics", "swing", "vote"];
        private static const CONVERSATION_AGREE:Array = ["happy", "vote"];
        private static const CONVERSATION_APATY:Array = ["indifferent", "question"];
        private static const CONVERSATION_DISAGREE:Array = ["angry", "no"];
        
        private var _spritemap:Spritemap;
        private var _bubble:Spritemap;
        private var _type:int;
        private var _move:Point;
        private var _noCollide:Boolean;
        
        private var _waypoint:Waypoint;
        private var _target:Entity;
        private var _interceptWeight:Number = 0.01;
        
        private var _tribe:Tribe;
        private var _currentPoll:Poll;
        private var _state:int;
        private var _timer:uint;
        private var _conversationLength:int;
        
        private var _isMinion:Boolean;
        private var _party:Party;

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
            
            setHitbox(48, 48, 24, 24);
            
            _bubble = new Spritemap(ICONS_IMAGE, 24, 24);
            _bubble.add("rosette", [0]);
            _bubble.add("question", [2]);
            _bubble.add("politics", [3]);
            _bubble.add("happy", [4]);
            _bubble.add("indifferent", [5]);
            _bubble.add("angry", [6]);
            _bubble.add("weather", [7]);
            _bubble.add("no", [8]);
            _bubble.add("plant", [9]);
            _bubble.add("hut", [10]);
            _bubble.add("swing", [11]);
            _bubble.add("vote", [12]);
            _bubble.add("flag", [13]);
            _bubble.centerOrigin();
            _bubble.y -= 30;
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
            _noCollide = false;
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
        
        public function get party():Party {
            return _party;
        }
        
        public function set party(p:Party):void {
            _party = p;
            tintColour = p.colour;
        }
        
        public function get isMinion():Boolean {
            return _isMinion;
        }
        
        public function makeMinion(party:Party):void {
            _isMinion = true;
            this.party = party;
            _bubble.play("rosette");
            _bubble.visible = true;
            // Once he becomes a minion, all he'll do is intercept
            _interceptWeight = 1.0;
        }

        // States
        public function wander():void {
            var p:Point = VectorMath.polar(FP.rand(360), FP.rand(200) + 100);
            p.x += _tribe.hut.x;
            p.y += _tribe.hut.y;
            moveToPoint(new Waypoint(p.x, p.y, null));
            _state = STATE_WANDER;
        }
        
        public function idle():void {
            stop();
            _noCollide = false;
            _state = STATE_IDLE;
        }
        
        public function intercept():void {
            _target = findTarget();
            _state = STATE_INTERCEPT;
        }
        
        public function enterHut():void {
            var nearest:Waypoint;
            var nearDist:Number;
            
            for each(var w:Waypoint in _tribe.hut.entryPoints) {
                var dist:Number = Math.sqrt((x - w.x) * (x - w.x) + (y - w.y) * (y - w.y));
                if(nearest == null || dist < nearDist) {
                    nearest = w;
                    nearDist = dist;
                }
            }
            
            moveToPoint(nearest);
            _noCollide = true;
            _state = STATE_ENTER_HUT;
        }
        
        public function exitHut():void {
            moveToPoint(_tribe.hut.exitPoint);
            _noCollide = true;
            _state = STATE_EXIT_HUT;
        }
        
        // Movement
        public function moveToPoint(waypoint:Waypoint):void {
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
        
        // Conversation
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
            _bubble.play(FP.choose(isMinion ? CONVERSATION_POLITICAL : CONVERSATION_IDLE));
            _bubble.visible = true;
            _timer = TALK_TIME + FP.rand(TALK_TIME_VARIANCE);
        }
        
        public function listen():void {
            stop();
            _state = STATE_CONVERSE_LISTEN;
            hideSpeechBubble();
        }
        
        private function hideSpeechBubble():void {
            _bubble.visible = isMinion;
            if(isMinion) {
                _bubble.play("rosette");
            }
        }
        
        public function startTalking():void {
            _conversationLength = 2+FP.rand(2);
        }

        public function stopTalking():void {
            var v:Voter = _target as Voter;
            idle();
            v.idle();
            
            // Spread party
            if(_isMinion) {
                v.party = _party;
            } else if(v._isMinion) {
                party = v._party;
            }
            
            hideSpeechBubble();
            
        }

        public function get isConversing():Boolean {
            return (_state == STATE_CONVERSE_READY || _state == STATE_CONVERSE_TALK || _state == STATE_CONVERSE_LISTEN) && _target != null;
        }
        
        public function converseInterrupt():Boolean {
            if(_state == STATE_IDLE || _state == STATE_WANDER) {
                _state = STATE_CONVERSE_READY;
            }
            return _state == STATE_CONVERSE_READY;
        }
        
        // Voting/party stuff
        public function vote(poll:Poll):void {
            if(_party != null && poll.parties.indexOf(_party) != -1) {
                // Go to the polling station
                _currentPoll = poll;
                enterHut();
            } else {
                poll.abstain();
            }
        }
        
        override public function update():void {
            super.update();
            
            // Decrement timer
            if(_timer > 0) {
                _timer--;
            }
            
            // If wandering, move towards waypoint
            if((_state == STATE_WANDER || _state == STATE_ENTER_HUT || _state == STATE_EXIT_HUT) && _waypoint) {
                FP.point.x = _waypoint.x - x;
                FP.point.y = _waypoint.y - y;

                if(VectorMath.magnitude(FP.point) <= SPEED) {
                    _waypoint = _waypoint.parent;
                    if(_waypoint == null && _state == STATE_WANDER) {
                        idle();
                    } else if(_waypoint == null && _state == STATE_ENTER_HUT) {
                        // Vote on the current poll, then exit polling station
                        _currentPoll.castVote(_party);
                        _currentPoll = null;
                        exitHut();
                    } else if(_waypoint == null && _state == STATE_EXIT_HUT) {
                        idle();
                    }
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
                            startTalking();
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
                if(Math.random() < _interceptWeight && findTarget()) {
                    intercept();
                } else if(Math.random() < 0.1) {
                    // Wander again!
                    wander();
                }
            }
            
            // Move
            if(!collide("terrain", x + _move.x, y) || _noCollide) {
                x += _move.x;
            }
            if(!collide("terrain", x, y + _move.y) || _noCollide) {
                y += _move.y;
            }
            
            layer = -y - 24;
        }

        /**
         *  Resolve a target, and return true if one has been aquired.
         */
        private function findTarget():Entity {
            if(Main.gameworld == null) {
                return null;
            }
            
            var target:Entity = Main.gameworld.nearestToEntityFilter("mob", this, isMinion ? isNotTalkingRecruit : isNotTalking);
            
            var valid:Boolean = target != null && distanceFrom(target) <= INTERCEPT_RANGE;
            return valid ? target : null;
        }
        
        private function isNotTalkingRecruit(v:Voter):Boolean {
            return !v.isConversing && v.party == null;
        }
        private function isNotTalking(v:Voter):Boolean {
            return !v.isConversing;
        }
    }
}