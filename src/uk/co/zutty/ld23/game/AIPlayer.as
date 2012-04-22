package uk.co.zutty.ld23.game
{
    import flash.geom.Point;
    
    import net.flashpunk.FP;
    import net.noiseinstitute.basecode.VectorMath;
    
    import uk.co.zutty.ld23.GameWorld;
    import uk.co.zutty.ld23.entity.Billboard;
    import uk.co.zutty.ld23.entity.Voter;

    public class AIPlayer {
        
        private var _party:Party;
        private var _chosenRep:Voter;
        private var _builtBillboard:Boolean;
        
        public function AIPlayer() {
            _party = new Party("Tastycrats", 0x0000ff)
            _builtBillboard = false;
        }
        
        public function get party():Party {
            return _party;
        }
        
        public function update(world:GameWorld):void {
            if(_chosenRep == null) {
                _chosenRep = world.tribe.voters[0];
                _chosenRep.makeMinion(_party);
            } else if(!_builtBillboard) {
                var p:Point = VectorMath.polar(FP.rand(360), FP.rand(150) + 150);
                var h:Hut = world.tribe.hut;
                world.add(new Billboard(_party, p.x + h.x, p.y + h.y));
                _builtBillboard = true;
            }
        }
    }
}