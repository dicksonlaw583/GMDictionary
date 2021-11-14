///@func DictionaryTooSmallException(dictionary, n)
///@param {CheckWordDictionary|PickWordDictionary} dictionary The dictionary that the error is coming from
///@param {int} n The minimum size required for the operation
///@desc Exception thrown when a dictionary is too small for the given query
function DictionaryTooSmallException(dictionary, n) constructor {
	self.dictionary = dictionary;
	self.n = n;
	
	static toString = function() {
		return "Attempting to query " + string(self.n) + " word(s) from a dictionary of size " + string(self.dictionary.size) + ".";
	};
}
