extends Resource

 ## column name
@export var headers := []
## origin data
@export var records := [] :
	set(v):
		records = v
		if _auto_setup:
			setup()

var _data:= {}  #column name to index
var _data_by_key := {}
var _id2key := {} # id 和 key 的映射
var _key2id := {}
var _auto_setup = false
var _initialed = false
## _data getter
var data:
	get:
		return _data

func _init(auto_setup = false):
	_auto_setup = auto_setup


func setup():
	if _initialed:
		push_warning(">_< csv file already setuped !")
		return self
	_initialed = true
	var field_indexs = {}
	for i in range(headers.size()):
		field_indexs[headers[i]] = i

	for row in records:
		var primary_key = row[0]
		var row_data = {}
		for key in headers:
			var index = field_indexs[key]
			var value = row[index]
			row_data[key] = value
		_data[primary_key]= row_data
		var key = row_data.get("Key")
		if key:
			_data_by_key[key] = row_data
			_id2key[primary_key] = key
			_key2id[key] = primary_key
	headers.clear()
	records.clear()
	
	return self


func fetch(primary_key):
	var ret = _data.get(primary_key)
	if not ret:
		ret = _data_by_key.get(primary_key)
	return ret

func id2key(id):
	return _id2key.get(id)

func key2id(key):
	return _key2id.get(key)

func keys():
	return _data.keys()
