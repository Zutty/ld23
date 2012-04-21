package uk.co.zutty.ld23 {
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld23.entity.HutPart;
    import uk.co.zutty.ld23.entity.Terrain;
    import uk.co.zutty.ld23.entity.Voter;
    import uk.co.zutty.ld23.game.Party;
    import uk.co.zutty.ld23.game.Poll;

    public class GameWorld extends World {
        
        private var _parties:Vector.<Party>;
        private var _playerParty:Party;
        private var _voters:Vector.<Voter>;
        
        public function GameWorld() {
            super();
            
            _voters = new Vector.<Voter>();
            
            _parties = new Vector.<Party>();
            _playerParty = new Party("Fingerlickans", 0xff0000);
            _parties[_parties.length] = _playerParty;
            _parties[_parties.length] = new Party("Tastycrats", 0x0000ff);
            
            for(var i:int = 0; i < 10; i++) {
                add(Terrain.make(FP.rand(640), FP.rand(480), FP.choose(1,1,1,1,1,1,2,3,4,4,5,5,6,6,6)));
            }
            
            addHut(90, 120, 6);
        }
        
        private function addHut(x:Number, y:Number, voters:int):void {
            var colour:uint = 0xaaaaaa;//FP.choose(0xff0000, 0x0000ff, 0xffff00);
            var roof:HutPart = new HutPart(HutPart.PART_ROOF);
            roof.tintColour = colour;
            roof.x = x;
            roof.y = y;
            add(roof)
            var floor:HutPart = new HutPart(HutPart.PART_FLOOR);
            floor.tintColour = colour;
            floor.x = x;
            floor.y = y;
            add(floor)
            
            for(var i:int = 0; i < voters; i++) {
                addVoter(FP.choose(1,2,3,4), x - 120 + FP.rand(240), y - 120 + FP.rand(240));            
            }
        }
        
        private function addVoter(type:int, x:Number, y:Number):Voter {
            var v:Voter = new Voter(type);
            v.x = x;
            v.y = y;
            v.move(FP.rand(360));
            v.tintColour = 0xaaaaaa;//FP.choose(0xff0000, 0x0000ff, 0xffff00);
            add(v);
            _voters[_voters.length] = v;
            return v;
        }
        
        override public function update():void {
            super.update();
            
            if(Input.pressed(Key.SPACE)) {
                var poll:Poll = new Poll(_voters.length, _parties);
                
                for each(var voter:Voter in _voters) {
                    var vote:Party = voter.vote(poll);
                    if(vote) {
                        poll.countVote(vote);
                        voter.tintColour = vote.colour;
                    }
                }
            }
        }
    }
}
