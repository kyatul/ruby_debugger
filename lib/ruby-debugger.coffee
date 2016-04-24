{CompositeDisposable} = require 'atom'

module.exports =
  activate: (@state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add('atom-workspace', {
      'ruby-debugger:breakpoint': => @breakpoint()
      'ruby-debugger:toggle': => @toggle()
    })


  breakpoint: ->
    @editor = atom.workspace.getActiveTextEditor()
    @current_row = (@editor.getCursorBufferPosition()).toArray()[0]
    @current_text = @editor.lineTextForBufferRow(@current_row)

    if @current_text.indexOf('binding.pry') >= 0
      @remove_breakpoint()
      if @editor.getText().indexOf("binding.pry") < 0
        @remove_debug_header()
    else
      if @editor.getText().indexOf("binding.pry") < 0
        @add_debug_header()
      @add_breakpoint()

    @editor.save()

  toggle: ->

  no_breakpoint: ->
    @editor.getText().indexOf("binding.pry") < 0

  add_breakpoint: ->
    @editor.moveToFirstCharacterOfLine()
    @editor.insertText("binding.pry")
    @editor.insertNewline()

  remove_breakpoint: ->
    @editor.moveToBeginningOfLine()
    @editor.deleteToEndOfLine()
    @editor.delete()

  remove_debug_header: ->
    buffer_text = @editor.getText()
    buffer_text = buffer_text.split("require 'pry'").join("\n")
    @editor.setText(buffer_text)
    @editor.delete()

  add_debug_header:  ->
    current_position = @editor.getCursorBufferPosition()

    @editor.moveToTop()
    @editor.insertText("require 'pry'")
    @editor.insertNewline()
    @editor.setCursorBufferPosition(current_position)
