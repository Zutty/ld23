package uk.co.zutty.ld23 {
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld23.entity.Voter;

    public class GameWorld extends World {
        public function GameWorld() {
            super();
            addVoter(1);            
            addVoter(2);            
            addVoter(3);            
            addVoter(4);            
        }
        
        private function addVoter(type:int):Voter {
            var v:Voter = new Voter(type);
            v.x = FP.rand(640);
            v.y = FP.rand(480);
            v.move(FP.rand(360));
            v.tintColour = FP.choose(0xff0000, 0x0000ff, 0xffff00);
            add(v);
            return v;
        }
    }
}
