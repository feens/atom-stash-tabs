module.exports =
  stashedFiles: []
  activeFile: null

  activate: (state) -> # ...
    atom.workspaceView.command 'stash-tabs:stash', => @stash()
    atom.workspaceView.command 'stash-tabs:unstash', => @unstash()

  stash: ->
    stashedFiles = []
    @activeFile = atom.workspace.paneContainer.activePane.getActiveItem().getPath()
    atom.workspace.getTextEditors().forEach (editor) ->
      stashedFiles.push editor.getPath()
      atom.workspace.paneContainer.activePane.destroyItem(editor)

    @stashedFiles = stashedFiles


  unstash: ->
    if @stashedFiles.length > 0
      atom.workspace.paneContainer.activePane.destroyItems()
      activeFile = @activeFile
      activeEditor = null
      @stashedFiles.forEach (file) ->
        editor = atom.workspace.open file, {activatePane: false}

        if file == activeFile
          activeEditor = editor

      if activeEditor
        console.log 'found an editor to activate', activeEditor
        activeEditor.then (editor) ->
          console.log 'active editor', editor
          atom.workspace.paneContainer.activePane.activateItem(editor)


      @stashedFiles = []
      @activeFile = null
