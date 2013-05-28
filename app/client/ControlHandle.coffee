
  onControlToJson = ->
    rootNode = document.getElementById("root")
    if rootNode?
      document.getElementById("textarea").value = JSON.stringify(convertDivToJson(document.getElementById("root")))
    else
      console.log "onControlToJson root node is null"
    
  getColorByDepth = (depth) ->
    alpha = 255 - (depth % 5 + 1) * 20
    "rgb(" + alpha + "," + alpha + "," + alpha + ")"

  insertAfter = (newEl, targetEl) ->
    parentEl = targetEl.parentNode
    if parentEl.lastChild is targetEl
      parentEl.appendChild newEl
    else
      parentEl.insertBefore newEl, targetEl.nextSibling
  
  onJsonToControl = ->
    document.body.removeChild document.getElementById("root") if document.getElementById("root")?

    rootDiv = createDivFromJsonObject(JSON.parse(document.getElementById("textarea").value), "root")
    rootDiv.id = "root"
    document.body.appendChild rootDiv
    divNodes = document.getElementsByTagName("div")

    for divNode in divNodes
      divDepth = 0
      parentDiv = divNode
      while parentDiv
        if parentDiv is rootDiv
          divNode.style.backgroundColor = getColorByDepth(divDepth)
          break
        parentDiv = parentDiv.parentNode
        divDepth++

  onClearControl = ->
    document.body.removeChild document.getElementById("root") if document.getElementById("root")?

  @onControlToJson = onControlToJson
  @onJsonToControl = onJsonToControl
  @onClearControl = onClearControl
