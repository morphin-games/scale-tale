class_name ArgGetter
extends RefCounted

## Returns the value of a given argument through the command line.
## If no argument of the same name as any of the arg_names is found, returns an empty string.
static func get_arg(arg_names : Array[String], args : Array[String]) -> String:
	for i in range(0, args.size()):
		for j in range(0, arg_names.size()):
			if(args[i] != arg_names[j]): continue
			if(i >= args.size() - 1): continue
			return args[i + 1]
	return ""
