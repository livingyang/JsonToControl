(function() {

	function onControlToJson () {
		var rootNode = document.getElementById("root");
		if (!rootNode) {
			console.log("onControlToJson root node is null");
			return;
		};

		document.getElementById("textarea").value = JSON.stringify(convertDivToJson(document.getElementById("root")));
	}

	function getColorByDepth (depth) {
		var alpha = 255 - (depth % 5) * 20;

		return "rgb(" + alpha + "," + alpha + "," + alpha + ")";
	}

	function insertAfter(newEl, targetEl) {

		var parentEl = targetEl.parentNode;

		if(parentEl.lastChild == targetEl)
		{
			parentEl.appendChild(newEl);
		}else
		{
			parentEl.insertBefore(newEl,targetEl.nextSibling);
		}            
	}

	function onJsonToControl () {

		var rootNode = document.getElementById("root");
		if (rootNode) {
			rootNode.parentNode.removeChild(rootNode);
		};

		var rootDiv = createDivFromJsonObject(JSON.parse(document.getElementById("textarea").value));
		rootDiv.id = "root";
		document.body.appendChild(rootDiv);

		// change div background color
		var divNodes = document.getElementsByTagName("div");
		for (var i = 0; i < divNodes.length; ++i) {

			var divDepth = 0;
			var divNode = divNodes[i];
			var parentDiv = divNode;

			while (parentDiv) {
				if (parentDiv == document.body) {
					break;
				};

				parentDiv = parentDiv.parentNode;
				divDepth++;
			}

			divNode.style.backgroundColor = getColorByDepth(divDepth);
		}

		// add <br/> to every input
		var inputNodes = document.getElementsByTagName("input");
		for (var i = 0; i < inputNodes.length; ++i) {
			insertAfter(document.createElement("br"), inputNodes[i]);
		}
	}

	function onClearControl () {
		
		var rootNode = document.getElementById("root");
		if (rootNode) {
			rootNode.parentNode.removeChild(rootNode);
		};
	}

	this.onControlToJson = onControlToJson;
	this.onJsonToControl = onJsonToControl;
	this.onClearControl = onClearControl;
	
}).call(this);