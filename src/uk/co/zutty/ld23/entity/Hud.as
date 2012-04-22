package uk.co.zutty.ld23.entity
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Text;
    
    import uk.co.zutty.ld23.GameWorld;
    import uk.co.zutty.ld23.Main;
    
    public class Hud extends Entity {
        
        private var _electionText:Text;
        private var _world:GameWorld;
        
        public function Hud(world:GameWorld) {
            super(0, 0);
            
            _world = world;
            
            layer = -65535;
            
            _electionText = new Text("", 160, 5);
            _electionText.size = 36;
            _electionText.color = 0x000000;
            addGraphic(_electionText);
            
            graphic.scrollX = 0;
            graphic.scrollY = 0;
        }
        
        override public function update():void {
            var time:int = Math.round(_world.pollTimer);
            var fmtTime:String = lz(time / 60) + ":" + lz(time % 60);
            _electionText.text = (_world.pollTimer <= 0) ? "Polls open!" : "Election in "+fmtTime;
        }
        
        private function lz(n:int):String {
            return n < 10 ? "0"+n : ""+n;
        }
    }
}