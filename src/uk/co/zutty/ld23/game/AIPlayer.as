package uk.co.zutty.ld23.game
{
    import uk.co.zutty.ld23.GameWorld;
    import uk.co.zutty.ld23.entity.Voter;

    public class AIPlayer {
        
        private var _party:Party;
        private var _chosenRep:Voter;
        
        public function AIPlayer() {
            _party = new Party("Tastycrats", 0x0000ff)
        }
        
        public function get party():Party {
            return _party;
        }
        
        public function update(world:GameWorld):void {
            if(_chosenRep == null) {
                _chosenRep = world.tribe.voters[0];
                _chosenRep.makeMinion(_party);
            }
        }
    }
}