package uk.co.zutty.ld23.game
{
    import uk.co.zutty.ld23.entity.Voter;

    public class Tribe {
        
        private var _hut:Hut;
        private var _voters:Vector.<Voter>;
        
        public function Tribe() {
            _voters = new Vector.<Voter>();
        }
        
        public function get size():Number {
            return _voters.length;
        }

        public function get hut():Hut {
            return _hut;
        }

        public function set hut(value:Hut):void {
            _hut = value;
        }

        public function get voters():Vector.<Voter> {
            return _voters;
        }

        public function addVoter(voter:Voter):void {
            _voters[_voters.length] = voter;
        }


    }
}