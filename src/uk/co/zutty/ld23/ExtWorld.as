package uk.co.zutty.ld23
{
    import net.flashpunk.Entity;
    import net.flashpunk.World;
    
    public class ExtWorld extends World {
        public function ExtWorld() {
            super();
        }
        
        public function nearestToEntityFilter(type:String, e:Entity, filter:Function):Entity {
            var n:Entity = _typeFirst[type],
                nearDist:Number = Number.MAX_VALUE,
                near:Entity, dist:Number,
                x:Number = e.x - e.originX,
                y:Number = e.y - e.originY;
            while (n)
            {
                if (n != e && filter(n))
                {
                    dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
                    if (dist < nearDist)
                    {
                        nearDist = dist;
                        near = n;
                    }
                }
                n = n._typeNext;
            }
            return near;
        }
    }
}