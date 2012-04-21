package uk.co.zutty.ld23.game
{
    public class Party {
        
        private var _name:String;
        private var _colour:uint;
        // Left wing or right wing?
        private var _wing:Number = 0;
        // Authoritarian or ibertarian?
        private var _auth:Number = 0;
        
        public function Party(name:String, colour:uint) {
            _name = name;
            _colour = colour;
        }
        
        public function get name():String {
            return _name;
        }

        public function set name(value:String):void {
            _name = value;
        }

        public function get colour():uint {
            return _colour;
        }
        
        public function set colour(value:uint):void {
            _colour = value;
        }
        
        public function get wing():Number {
            return _wing;
        }

        public function set wing(value:Number):void {
            _wing = value;
        }

        public function get auth():Number {
            return _auth;
        }

        public function set auth(value:Number):void {
            _auth = value;
        }

        
    }
}