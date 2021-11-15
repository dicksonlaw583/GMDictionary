///@func CheckWordDictionary(<source>)
///@arg {string|array|struct} <source> (Optional) Source file(s) to load from. See `load(source)` for details.
///@desc Constructor for a dictionary optimized for checking the existence of a word in a list.
function CheckWordDictionary() constructor {
	///@func load(source)
	///@arg {string|array|struct} source
	///@desc Load words into the dictionary from the given source. Return the number of words loaded.
	/// - If source is a string: Load from the given file.
	/// - If source is an array: Load from each file in the array.
	/// - If source is a struct: Load from each file in the struct's keys where the corresponding value is true.
	static load = function(source) {
		var n = 0;
		if (is_string(source)) {
			for (var f = file_text_open_read(source); !file_text_eof(f); file_text_readln(f)) {
				var w = file_text_read_string(f);
				self.data[$ w] = 1;
				++n;
			}
			file_text_close(f);
			self.size += n;
		} else if (is_array(source)) {
			var sourceSize = array_length(source);
			for (var i = 0; i < sourceSize; ++i) {
				n += self.load(source[i]);
			}
		} else if (is_struct(source)) {
			var sourceKeys = variable_struct_get_names(source);
			var sourceSize = array_length(sourceKeys);
			for (var i = 0; i < sourceSize; ++i) {
				var k = sourceKeys[i];
				if (source[$ k]) {
					n += self.load(k);
				}
			}
		} else {
			show_error("Invalid type for source in CheckWordDictionary.load(source).", true);
		}
		return n;
	};
	
	///@func add(word)
	///@arg {string|array} word The string or array of strings to add into the dictionary
	///@desc Add a word or an array of words into the dictionary. Return the number of words added.
	static add = function(word) {
		if (is_string(word)) {
			self.data[$ word] = 1;
			++self.size;
			return 1;
		} else if (is_array(word)) {
			var n = array_length(word);
			for (var i = n-1; i >= 0; --i) {
				self.data[$ word[i]] = 1;
			}
			self.size += n;
			return n;
		}
	};
	
	///@func check(word)
	///@arg {string} word The string to check
	///@desc Return whether the given word is in the dictionary.
	static check = function(word) {
		if (self.size <= 0) {
			throw new DictionaryTooSmallException(self, 1);
		}
		return variable_struct_exists(self.data, word);
	};
	
	// Setup
	data = {};
	size = 0;
	if (argument_count > 0) {
		self.load(argument[0]);
	}
}

///@func PickWordDictionary(<source>)
///@arg {string|array|struct} <source> (Optional) Source file(s) to load from. See `load(source)` for details.
///@desc Constructor for a dictionary optimized for picking a random word from a list.
function PickWordDictionary() constructor {
	///@func load(source)
	///@arg {string|array|struct} source
	///@desc Load words into the dictionary from the given source. Return the number of words loaded.
	/// - If source is a string: Load from the given file.
	/// - If source is an array: Load from each file in the array.
	/// - If source is a struct: Load from each file in the struct's keys where the corresponding value is true.
	static load = function(source) {
		var n = 0;
		if (is_string(source)) {
			for (var f = file_text_open_read(source); !file_text_eof(f); file_text_readln(f)) {
				var w = file_text_read_string(f);
				array_push(self.data, w);
				++n;
			}
			file_text_close(f);
			self.size += n;
		} else if (is_array(source)) {
			var sourceSize = array_length(source);
			for (var i = 0; i < sourceSize; ++i) {
				n += self.load(source[i]);
			}
		} else if (is_struct(source)) {
			var sourceKeys = variable_struct_get_names(source);
			var sourceSize = array_length(sourceKeys);
			for (var i = 0; i < sourceSize; ++i) {
				var k = sourceKeys[i];
				if (source[$ k]) {
					n += self.load(k);
				}
			}
		} else {
			show_error("Invalid type for source in CheckWordDictionary.load(source).", true);
		}
		return n;
	};
	
	///@func add(word)
	///@arg {string|array} word The string or array of strings to add into the dictionary
	///@desc Add a word or an array of words into the dictionary. Return the number of words added.
	static add = function(word) {
		if (is_string(word)) {
			array_push(self.data, word);
			++self.size;
			return 1;
		} else {
			var n = array_length(word);
			array_copy(self.data, self.size, word, 0, n);
			self.size += n;
			return n;
		}
	};
	
	///@func pick()
	///@desc Return a random word from the dictionary.
	static pick = function() {
		if (self.size <= 0) {
			throw new DictionaryTooSmallException(self, 1);
		}
		return self.data[irandom(self.size-1)];
	};
	
	///@func pickN(n, <largeMode>)
	///@arg {int} n Number of words to pick
	///@arg {bool} largeMode
	///@desc Return an array of n random unique words from the dictionary.
	/// - If largeMode is false (default): Pick n times randomly from the dictionary and re-pick on duplication.
	/// - If largeMode is true: Shuffle a copy of the dictionary's inner data, and pick the first n words.
	static pickN = function(n, largeMode=false) {
		if (self.size < n) {
			throw new DictionaryTooSmallException(self, n);
		}
		var result;
		if (largeMode) {
			result = array_create(self.size);
			array_copy(result, 0, self.data, 0, self.size);
			for (var i = self.size-1; i >= 1; --i) {
				var j = irandom(i);
				var temp = result[i];
				result[@ i] = result[j];
				result[@ j] = temp;
			}
			array_resize(result, n);
		} else {
			result = array_create(n);
			var seenWords = {};
			for (var i = n-1; i >= 0; --i) {
				do {
					var pickedWord = self.data[irandom(self.size-1)];
				} until (!variable_struct_exists(seenWords, pickedWord));
				seenWords[$ pickedWord] = 1;
				result[@ i] = pickedWord;
			}
		}
		return result;
	};
	
	// Setup
	data = [];
	size = 0;
	if (argument_count > 0) {
		self.load(argument[0]);
	}
}
