package uk.co.zutty.ld23.entity
{
    import flash.geom.Rectangle;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    public class Terrain extends Entity {
        
        [Embed(source = 'natural.png')]
        public static const TERRAIN_IMAGE:Class;
        
        private var _width:int;
        private var _height:int;
        
        private var _image:Image;
        
        public function Terrain(x:Number, y:Number, offX:int, offY:int, background:Boolean) {
            super(x, y);
            
            _image = new Image(TERRAIN_IMAGE, new Rectangle(offX * 48, offY * 48, 48, 48));
            _image.centerOrigin();
            graphic = _image;
            
            layer = background ? 90000 : -y - 24;
        }
        
        public static function make(x:Number, y:Number, type:int):Terrain {
            return new Terrain(x, y, type % 3, type / 3, type <= 3);            
        }
    }
}