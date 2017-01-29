{CompositeDisposable} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = ActivatefrogMode =
  subscriptions: null
  active: false
  frogPath: path.join(__dirname, '../frogs/').replace(/\\/g, '/')
  frogArray: []
  frog_loop: null
  current_frog:null

  loadfolder: (frogPath) ->
    @frogArray = fs.readdirSync frogPath

  randomfrog: (frogArray) ->
    @numfrogs = frogArray.length
    if @numfrogs != 0
      @randomnum = Math.floor (Math.random() * @numfrogs)
      @current_frog = frogArray[@randomnum]
    else console.log "REEEEEE no frogs"

  setbackground: (imagePath) ->
    # TODO: Delete
    elem = document.getElementsByTagName('atom-text-editor')[0]
    editor = atom.workspace.getActiveTextEditor()
    editorElement = atom.views.getView editor

    frogimg = document.getElementById('frog-img')
    frogimg?.parentNode.removeChild(frogimg)
    if imagePath != ''

      image = document.createElement('img')
      image.setAttribute('id', 'frog-img')
      image.setAttribute('class', 'frog-img')
      image.setAttribute('src', imagePath)
      editorElement.appendChild(image)

  setrandomfrog: ->
    #console.log "loops"
    @randomfrog(@frogArray)
    @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
     "activate-frog-mode:toggle": => @toggle()
     "activate-frog-mode:enable":  => @enable()
     "activate-frog-mode:disable": => @disable()
    @activeItemSubscription = atom.workspace.onDidStopChangingActivePaneItem =>
      @subscribeToActiveTextEditor()

  subscribeToActiveTextEditor: ->
    console.log "changed editor"
    @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')

  deactivate: ->
    @subscriptions?.dispose()
    @active = false

  toggle: ->
    #console.log @frogPath
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    console.log "ACTIVATE frog MODE"
    @loadfolder @frogPath
    @randomfrog(@frogArray)
    #console.log @frogPath
    #console.log @current_frog
    @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')
    @setrandomfrog()
    @change_frog_loop()

  change_frog_loop: ->
    if not @active
      console.log "not active"
      clearInterval(change_frog_loop)

    callback = => @setrandomfrog()
    @frog_loop = setInterval(callback, 15000)

  disable: ->
    @active = false
    clearInterval(@frog_loop)
    @setbackground ''
    console.log 'feelsbadman.jpg'
