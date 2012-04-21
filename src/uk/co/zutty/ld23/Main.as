package uk.co.zutty.ld23
{
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    [SWF(width="640", height="480", frameRate="60", backgroundColor="000000")]
    public class Main extends Engine {
        public function Main() {
            super(640, 480, 60, false);
            
            FP.screen.color = 0xcaa2c8;
            //FP.console.enable();

            FP.world = new GameWorld();
        }
    }
}