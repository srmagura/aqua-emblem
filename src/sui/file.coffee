window._file = {}
_file.fs = {}

_file.difficulty = {
    normal: {statBonus: 1, expMultiplier: 4/3},
    hard: {statBonus: 0, expMultiplier: 1}
}

class _file.File

    setFileState: (fsCls) ->
        @fileState = new fsCls(this)

    init: ->
        @fileState.init()
        
    pickle: ->
        obj = {
            'difficultyStr': @difficultyStr
            'fsCls': _util.getFunctionName(@fileState.constructor),
            'playerTeam': @playerTeam.pickle()
        }
        
        return JSON.stringify(obj)
        
    @unpickle: (str) ->
        try
            pickled = $.parseJSON(str)
        catch error
            console.log 'File.unpickle: could not parse JSON.'
            return null
            
        if not pickled?
            return null
                
        file = new _file.File()
        
        if 'difficultyStr' of pickled
            file.difficultyStr = pickled.difficultyStr
            file.difficulty = _file.difficulty[file.difficultyStr]
        else
            return null
            
        if 'fsCls' of pickled
            fsCls = pickled.fsCls
            
            if fsCls of _file.fs
                file.setFileState(_file.fs[fsCls])
            else
                return null
        else
            return null
    
        file.playerTeam = _team.PlayerTeam.unpickle(pickled.playerTeam)
        if file.playerTeam is null
            return null
            
        return file       


class _file.FileState

    constructor: (@file) ->

    chapterComplete: =>
        @ui.destroy()
        
        @file.setFileState(@nextFs)
        localStorage.setItem('file', @file.pickle())
        
        @ui = new _sui.StartUI(@file)
        @ui.init({message: @ui.messages.chapterComplete})


_file.createNewFile = (difficultyStr) ->
    file = new _file.File()
    file.difficultyStr = difficultyStr
    file.difficulty = _file.difficulty[difficultyStr]
    file.setFileState(_file.fs.Chapter1)
    
    playerUnits = [
        new _unit.special.Ace(),
        new _unit.special.Arrow(),
        new _unit.special.Luciana(),
        new _unit.special.Kenji(),
    ]
    
    file.playerTeam = new _team.PlayerTeam(playerUnits)
    return file
