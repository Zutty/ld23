package uk.co.zutty.ld23 {
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    import net.noiseinstitute.basecode.VectorMath;
    
    import uk.co.zutty.ld23.entity.Billboard;
    import uk.co.zutty.ld23.entity.Hud;
    import uk.co.zutty.ld23.entity.HutPart;
    import uk.co.zutty.ld23.entity.Terrain;
    import uk.co.zutty.ld23.entity.Voter;
    import uk.co.zutty.ld23.game.AIPlayer;
    import uk.co.zutty.ld23.game.Hut;
    import uk.co.zutty.ld23.game.Party;
    import uk.co.zutty.ld23.game.Poll;
    import uk.co.zutty.ld23.game.Tribe;

    public class GameWorld extends ExtWorld {
        
        private static const AI_UPDATE_TIME:int = 100;
        private static const POLL_TIME_SECONDS:Number = 60;
        
        private var _parties:Vector.<Party>;
        private var _aiPlayers:Vector.<AIPlayer>;
        private var _nextAiPlayer:uint;
        private var _aiUpdateTimer:int;
        private var _playerParty:Party;
        private var _tribe:Tribe;
        private var _currentPoll:Poll;
        private var _pollTimer:Number;
        private var _hud:Hud;
        
        public function GameWorld() {
            super();
            
            _parties = new Vector.<Party>();
            _playerParty = new Party("Fingerlickans", 0xff0000);
            _parties[_parties.length] = _playerParty;
            
            _aiPlayers = new Vector.<AIPlayer>();
            var ai:AIPlayer = new AIPlayer();
            _parties[_parties.length] = ai.party;
            _aiPlayers[_aiPlayers.length] = ai;
            _nextAiPlayer = 0;
            
            for(var i:int = 0; i < 10; i++) {
                add(Terrain.make(FP.rand(640), FP.rand(480), FP.choose(1,1,1,1,1,1,2,3,4,4,5,5,6,6,6)));
            }
            
            _tribe = makeTribe(320, 240, 6);
            _aiUpdateTimer = AI_UPDATE_TIME;
            
            _hud = new Hud(this);
            add(_hud);
            
            _pollTimer = POLL_TIME_SECONDS;
        }
        
        public function get pollTimer():Number {
            return _pollTimer;
        }
        
        public function get tribe():Tribe {
            return _tribe;
        }
        
        private function makeTribe(x:Number, y:Number, voters:int):Tribe {
            var tribe:Tribe = new Tribe();
            
            var hut:Hut = new Hut(x, y);
            add(hut.roof)
            add(hut.floor)
            tribe.hut = hut;
            
            for(var i:int = 0; i < voters; i++) {
                var p:Point = VectorMath.polar(FP.rand(360), FP.rand(100) + 100);

                addVoter(tribe, FP.choose(1,2,3,4), p.x + x, p.y + y);            
            }
            
            return tribe;
        }
        
        private function addVoter(tribe:Tribe, type:int, x:Number, y:Number):Voter {
            var v:Voter = new Voter(tribe, type);
            v.x = x;
            v.y = y;
            v.tintColour = 0xaaaaaa;
            add(v);
            return v;
        }
        
        override public function update():void {
            super.update();
            
            if(_aiUpdateTimer > 0) {
                _aiUpdateTimer--;
            }
            
            if(_pollTimer > 0) {
                _pollTimer -= FP.elapsed;
            }
            
            if(_aiUpdateTimer == 0) {
                _aiPlayers[_nextAiPlayer].update(this);
                _nextAiPlayer = (_nextAiPlayer + 1) % _aiPlayers.length;
                _aiUpdateTimer = AI_UPDATE_TIME;
            }
            
            if(_pollTimer <= 0 && _currentPoll == null) {
                _currentPoll = new Poll(_tribe.size, _parties);
                
                for each(var voter:Voter in _tribe.voters) {
                    voter.vote(_currentPoll);
                }
            }
                
            if(_currentPoll != null && _currentPoll.isClosed) {
                _pollTimer = POLL_TIME_SECONDS;
                _currentPoll.countVotes();
                _tribe.hut.tintColour = (_currentPoll.winner) ? _currentPoll.winner.colour : 0xaaaaaa;
                trace("turnout: "+_currentPoll.turnoutPct+"%");
                _currentPoll = null;
            }
            
            if(Input.mousePressed) {
                var picked:Entity = collidePoint("mob", mouseX, mouseY);
                
                if(picked && picked is Voter) {
                    var v:Voter = picked as Voter;
                    v.makeMinion(_playerParty);
                } else {
                    add(new Billboard(_playerParty, mouseX, mouseY));
                }
            }
        }
    }
}
