package uk.co.zutty.ld23.entity
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Spritemap;
    import net.noiseinstitute.basecode.VectorMath;
    
    public class HutPart extends Entity {

        [Embed(source = 'hut.png')]
        private static const HUT_IMAGE:Class;
        
        public static const PART_ROOF:int = 0;
        public static const PART_FLOOR:int = 1;
        
        private var _image:Image;
        private var _type:int;
        private var _isFloor:Boolean;

        public function HutPart(part:int, flip:Boolean, type:int = 1) {
            super();
            
            _image = new Image(HUT_IMAGE, new Rectangle(144 * part, 0, 144, 144));
            _image.centerOrigin();
            //_image.flipped = flip;
            graphic = _image;
            
            _isFloor = part == PART_FLOOR;
            layer = _isFloor ? 65535 : -y - 72;
            
            setHitbox(144, 78, 72, 48);
            collidable = true;
            this.type = "terrain";
            
            _type = type;
            
            // HACK!
            _image.tintMode = 1;//Image.TINTING_COLORIZE;
            _image.tinting = -.8;
        }
        
        public function set tintColour(colour:uint):void {
            _image.color = ~colour;
        }
        
        override public function update():void {
            super.update();
            layer = _isFloor ? 65535 : -y - 72;
        }
    }
}