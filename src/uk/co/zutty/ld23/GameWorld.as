package uk.co.zutty.ld23 {
    import flash.geom.Point;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    import net.noiseinstitute.basecode.VectorMath;
    
    import uk.co.zutty.ld23.entity.HutPart;
    import uk.co.zutty.ld23.entity.Terrain;
    import uk.co.zutty.ld23.entity.Voter;
    import uk.co.zutty.ld23.game.Hut;
    import uk.co.zutty.ld23.game.Party;
    import uk.co.zutty.ld23.game.Poll;
    import uk.co.zutty.ld23.game.Tribe;

    public class GameWorld extends World {
        
        private var _parties:Vector.<Party>;
        private var _playerParty:Party;
        private var _tribe:Tribe;
        
        public function GameWorld() {
            super();
            
            _parties = new Vector.<Party>();
            _playerParty = new Party("Fingerlickans", 0xff0000);
            _parties[_parties.length] = _playerParty;
            _parties[_parties.length] = new Party("Tastycrats", 0x0000ff);
            
            for(var i:int = 0; i < 10; i++) {
                add(Terrain.make(FP.rand(640), FP.rand(480), FP.choose(1,1,1,1,1,1,2,3,4,4,5,5,6,6,6)));
            }
            
            _tribe = makeTribe(240, 160, 6);
        }
        
        private function makeTribe(x:Number, y:Number, voters:int):Tribe {
            var tribe:Tribe = new Tribe();
            
            var colour:uint = 0xaaaaaa;//FP.choose(0xff0000, 0x0000ff, 0xffff00);
            var hut:Hut = new Hut(x, y);
            add(hut.roof)
            add(hut.floor)
            tribe.hut = hut;
            
            for(var i:int = 0; i < voters; i++) {
                var p:Point = VectorMath.polar(FP.rand(360), FP.rand(100) + 100);
                p.x += tribe.hut.x;
                p.y += tribe.hut.y;

                addVoter(tribe, FP.choose(1,2,3,4), p.x, p.y);            
            }
            
            return tribe;
        }
        
        private function addVoter(tribe:Tribe, type:int, x:Number, y:Number):Voter {
            var v:Voter = new Voter(tribe, type);
            v.x = x;
            v.y = y;
            v.wander();
            v.tintColour = 0xaaaaaa;//FP.choose(0xff0000, 0x0000ff, 0xffff00);
            add(v);
            return v;
        }
        
        override public function update():void {
            super.update();
            
            if(Input.pressed(Key.SPACE)) {
                var poll:Poll = new Poll(_tribe.size, _parties);
                
                for each(var voter:Voter in _tribe.voters) {
                    var vote:Party = voter.vote(poll);
                    if(vote) {
                        poll.castVote(vote);
                        voter.tintColour = vote.colour;
                    }
                }
                
                poll.countVotes();
                
                _tribe.hut.tintColour = (poll.winner) ? poll.winner.colour : 0xaaaaaa;
            }
        }
    }
}
