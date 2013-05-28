
# add table label

# add table item label

# add div label

  setElementJsonKey = (divNode, jsonKey) ->
    divNode.jsonKey = jsonKey

  getElementJsonKey = (divNode) ->
    divNode.jsonKey

  getInputValue = (input) ->
    switch input.type
      when "text"
        input.value
      when "number"
        new Number(input.value)
      when "checkbox"
        new Boolean(input.checked)
      else
        "0"

  createInputFromValue = (value) ->
    input = document.createElement("input")
    input.value = value
    input.className = "input-small"
    switch typeof (value)
      when "string"
        input.type = "text"
      when "number"
        input.type = "number"
      when "boolean"
        input.type = "checkbox"
        input.checked = value
      else
        input.type = "text"
        input.value = "undefined"
    input

  convertDivToJson = (divNode) ->
    jsonObj = {}
    unless divNode.tagName is "DIV"
      console.log "convertDivToJson root node is not div"
      return jsonObj
    for nodeIndex of divNode.childNodes
      nodeChild = divNode.childNodes[nodeIndex]
      switch nodeChild.tagName
        when "INPUT"
          jsonObj[getElementJsonKey nodeChild] = getInputValue(nodeChild)
        when "DIV"
          if nodeChild.title is "array"
            arrayJson = new Array()
            for arrayItemIndex of nodeChild.childNodes
              arrayItem = nodeChild.childNodes[arrayItemIndex]
              arrayJson.push convertDivToJson(arrayItem)  if arrayItem.tagName is "DIV"
            jsonObj[getElementJsonKey nodeChild] = arrayJson
          else
            jsonObj[getElementJsonKey nodeChild] = convertDivToJson(nodeChild)
    jsonObj

  createDivFromJsonObject = (jsonObject, jsonKey) ->
    divNode = document.createElement("div")
    divNode.className = "well"
    setElementJsonKey divNode, jsonKey or "undefined"
    for key of jsonObject
      childValue = jsonObject[key]
      if childValue instanceof Array
        subTableDivNode = document.createElement("div")
        # subTableDivNode.className = key
        setElementJsonKey subTableDivNode, key
        subTableDivNode.title = "array"
        divNode.appendChild subTableDivNode
        # subTableDivNodeLabel = document.createElement("p")
        # subTableDivNodeLabel.innerHTML = "Table:" + key
        # subTableDivNode.insertBefore subTableDivNodeLabel, subTableDivNode.childNodes[0]
        for childItemIndex of childValue
          childItemValue = childValue[childItemIndex]
          if childItemValue instanceof Object and (childItemValue instanceof Array is false)
            tableItemNode = createDivFromJsonObject(childItemValue)
            subTableDivNode.appendChild tableItemNode
            tableItemDivNodeLabel = document.createElement("h4")
            tableItemDivNodeLabel.innerHTML = key + "[" + childItemIndex + "]"
            tableItemNode.insertBefore tableItemDivNodeLabel, tableItemNode.childNodes[0]
        continue

      if childValue instanceof Object
        subDivNode = createDivFromJsonObject(childValue, key)
        divNode.appendChild subDivNode
        subDivNodeLabel = document.createElement("h3")
        subDivNodeLabel.innerHTML = key + ":"
        subDivNode.insertBefore subDivNodeLabel, subDivNode.childNodes[0]
        continue

      span = document.createElement("span")
      span.innerHTML = key + ":"
      span.className = "add-on"
      divNode.appendChild span
      input = createInputFromValue(childValue)
      setElementJsonKey input, key
      # input.className = key
      divNode.appendChild input
    divNode

  @convertDivToJson = convertDivToJson
  @createDivFromJsonObject = createDivFromJsonObject
