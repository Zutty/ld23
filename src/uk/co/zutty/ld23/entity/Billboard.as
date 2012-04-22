package uk.co.zutty.ld23.entity
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    
    import uk.co.zutty.ld23.Waypoint;
    import uk.co.zutty.ld23.game.Party;
    
    public class Billboard extends Entity {
        
        [Embed(source = 'billboard.png')]
        private static const BILLBOARD_IMAGE:Class;

        private var _party:Party;
        private var _image:Image;
        private var _viewingPoints:Array;
        
        public function Billboard(party:Party, x:Number, y:Number) {
            super(x, y);
            
            var flip:Boolean = FP.rand(10) < 5;
            
            _party = party;
            
            _image = new Image(BILLBOARD_IMAGE); 
            _image.centerOrigin();
            _image.flipped = flip;
            addGraphic(_image);
            
            var text:Text = new Text("VOTE\n"+_party.name, 0, 0);
            text.align = "center";
            text.size = 20;
            text.smooth = true;
            text.height = 120;
            text.height = 55;
            text.color = _party.colour;
            text.scaleX = 0.8;
            text.angle = flip ? -5 : 5;
            text.centerOrigin();
            addGraphic(text);
            
            type = "terrain";
            
            setHitbox(120, 20, 60, -24);
            
            layer = -y - 48;
            
            // Set up viewing waypoints
            var view:Waypoint = new Waypoint(x, y + 50);
            var l:Waypoint = new Waypoint(x - 90, y, view);
            var r:Waypoint = new Waypoint(x + 90, y, view);
            _viewingPoints = [view, l, r];
        }
        
        public function get viewingPoints():Array {
            return _viewingPoints;
        }
    }
}