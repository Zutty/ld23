package uk.co.zutty.ld23
{
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.graphics.Text;
    
    [SWF(width="640", height="480", frameRate="60", backgroundColor="000000")]
    public class Main extends Engine {

        [Embed(source = 'OpenComicFont.ttf', embedAsCFF="false", fontFamily = 'opencomic')]
        private static const OPENCOMIC_FONT:Class;

        public function Main() {
            super(640, 480, 60, false);
            
            FP.screen.color = 0xcaa2c8;
            FP.console.enable();
            
            Text.font = "opencomic";

            FP.world = new GameWorld();
        }
        
        public static function get gameworld():GameWorld {
            return FP.world is GameWorld ? FP.world as GameWorld : null;
        }
    }
}