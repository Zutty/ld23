package uk.co.zutty.ld23 {
    import net.flashpunk.World;
    
    import uk.co.zutty.ld23.entity.Voter;

    public class GameWorld extends World {
        public function GameWorld() {
            super();
            
            var v:Voter = new Voter();
            v.x = 50;
            v.y = 50;
            add(v);
        }
    }
}
