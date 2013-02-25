	function getInputValue (input) {
		switch (input.type)
		{
			case "text":
			return input.value;
			case "number":
			return new Number(input.value);
			case "checkbox":
			return new Boolean(input.checked);
			default:
			return "0";
		}
	}

	function createInputFromValue (value) {

		var input = document.createElement("input");
		input.value = value;

		switch (typeof(value))
		{
			case "string":
			input.type = "text";
			break;
			case "number":
			input.type = "number";
			break;
			case "boolean":
			input.type = "checkbox";
			input.checked = value;
			break;
		}

		return input;
	}

	function convertDivToJson(divNode)
	{
		var jsonObj = {};

		if (divNode.tagName != "DIV") {
			console.log("convertDivToJson root node is not div");
			return jsonObj;
		};

		for (var nodeIndex in divNode.childNodes)
		{
			var nodeChild = divNode.childNodes[nodeIndex];

			switch (nodeChild.tagName)
			{
				case "INPUT":
				jsonObj[nodeChild.className] = getInputValue(nodeChild);
				break;
				case "DIV":

				if (nodeChild.title == "array") {

					var arrayJson = new Array();

					for (var arrayItemIndex in nodeChild.childNodes)
					{
						var arrayItem = nodeChild.childNodes[arrayItemIndex];

						if (arrayItem.tagName == "DIV") {
							arrayJson.push(convertDivToJson(arrayItem));
						};
					}

					jsonObj[nodeChild.className] = arrayJson;
				}
				else
				{
				jsonObj[nodeChild.className] = convertDivToJson(nodeChild);
				}
				break;
			}
		}
		return jsonObj;
	}

	function createDivFromJsonObject(jsonObject)
	{
		var divNode = document.createElement("div");
		
		for (var key in jsonObject) {

			var childValue = jsonObject[key];

			if (childValue instanceof Array) {

				var subTableDivNode = document.createElement("div");
				subTableDivNode.className = key;
				subTableDivNode.title = "array";
				divNode.appendChild(subTableDivNode);

				for (var childItemIndex in childValue)
				{
					var childItemValue = childValue[childItemIndex];
					if (childItemValue instanceof Object && (childItemValue instanceof Array == false)) {
						subTableDivNode.appendChild(createDivFromJsonObject(childItemValue));
					};
				}

				continue;
			};

			if (childValue instanceof Object) {
				var subDivNode = createDivFromJsonObject(childValue);
				subDivNode.className = key;
				divNode.appendChild(subDivNode);
				continue;
			};

			var label = document.createElement("label");
			label.innerHTML = key + ":";
			divNode.appendChild(label);

			var input = createInputFromValue(childValue);
			input.className = key;
			divNode.appendChild(input);
		}

		return divNode;
	}
