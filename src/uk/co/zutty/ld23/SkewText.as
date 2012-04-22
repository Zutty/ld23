package uk.co.zutty.ld23
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    
    import net.flashpunk.graphics.Text;
    
    public class SkewText extends Text {
        public function SkewText(text:String, x:Number=0, y:Number=0, options:Object=null, h:Number=0) {
            super(text, x, y, options, h);
        }
        
        override public function render(target:BitmapData, point:Point, camera:Point):void {
            super.render(target, point, camera);
        }
    }
}