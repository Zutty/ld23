package uk.co.zutty.ld23.game
{
    import flash.utils.Dictionary;
    
    public class Poll {
        
        private var _parties:Vector.<Party>;
        private var _votes:Dictionary;
        private var _numEligable:Number;
        private var _numVoted:Number;
        private var _winner:Party = null;
        
        public function Poll(numEligable:int, parties:Vector.<Party>) {
            _numEligable = numEligable;
            _parties = parties;
            _votes = new Dictionary();
        }
        
        public function get parties():Vector.<Party> {
            return _parties;
        }
        
        public function castVote(party:Party):void {
            if(party == null) {
                return;
            }
            
            _numVoted++;
            
            if(!(party in _votes)) {
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
        
        public function countVotes():void {
            var mostVotes:Number = 0;
            
            for each(var party:Party in _parties) {
                if(_votes[party] > mostVotes) {
                    mostVotes = _votes[party];
                    _winner = party;
                }
            }
        }
            
        public function get winner():Party {
            return _winner;
        }
    }
}