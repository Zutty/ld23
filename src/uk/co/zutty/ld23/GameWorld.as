package uk.co.zutty.ld23 {
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld23.entity.HutPart;
    import uk.co.zutty.ld23.entity.Voter;

    public class GameWorld extends World {
        public function GameWorld() {
            super();
            addVoter(1, FP.rand(640), FP.rand(480));            
            addVoter(2, FP.rand(640), FP.rand(480));            
            addVoter(3, FP.rand(640), FP.rand(480));            
            addVoter(4, FP.rand(640), FP.rand(480));            
            addHut(90, 120);
        }
        
        private function addHut(x:Number, y:Number):void {
            var colour:uint = FP.choose(0xff0000, 0x0000ff, 0xffff00);
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
            
            addVoter(4, x, y);
        }
        
        private function addVoter(type:int, x:Number, y:Number):Voter {
            var v:Voter = new Voter(type);
            v.x = x;
            v.y = y;
            v.move(FP.rand(360));
            v.tintColour = FP.choose(0xff0000, 0x0000ff, 0xffff00);
            add(v);
            return v;
        }
    }
}
