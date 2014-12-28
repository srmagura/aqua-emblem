window._enemy = {}        
        
class _enemy.Mercenary extends _uclass.Mercenary

    constructor: (attr) ->
        if 'items' not of attr
            attr.items = [new _item.IronSword()]
    
        super(attr)
        
class _enemy.Soldier extends _uclass.Soldier

    constructor: (attr) ->
        if 'items' not of attr
            attr.items = [new _item.IronLance()]
    
        super(attr)
        
class _enemy.Fighter extends _uclass.Fighter

    constructor: (attr) ->
        if 'items' not of attr
            attr.items = [new _item.IronAxe()]
    
        super(attr)
        
class _enemy.Archer extends _uclass.Archer

    constructor: (attr) ->
        if 'items' not of attr
            attr.items = [new _item.IronBow()]
    
        super(attr)
