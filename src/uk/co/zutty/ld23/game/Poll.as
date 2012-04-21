package uk.co.zutty.ld23.game
{
    import flash.utils.Dictionary;
    
    public class Poll {
        
        private var _parties:Vector.<Party>;
        private var _votes:Dictionary;
        private var _numEligable:Number;
        private var _numVoted:Number;
        
        public function Poll(numEligable:int, parties:Vector.<Party>) {
            _numEligable = numEligable;
            _parties = parties;
            _votes = new Dictionary();
        }
        
        public function get parties():Vector.<Party> {
            return _parties;
        }
        
        public function countVote(party:Party):void {
            if(party == null) {
                return;
            }
            
            _numVoted++;
            
            if(!party in _votes) {
                _votes[party] = 0;
            }
            
            _votes[party]++;
        }
        
        public function getVotes(party:Party):Number {
            return (party in _votes) ? _votes[party] : 0;
        }
        
        public function get turnout():Number {
            return _numVoted / _numEligable;
        }
    }
}