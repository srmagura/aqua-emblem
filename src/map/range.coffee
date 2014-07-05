class window.Range

    constructor: (@min, @max) ->
        if not @max?
            @max = @min

        if @min?
            @array = [@min..@max]
        else
            @array = []

    contains: (i) ->
        return i in @array

    union: (range) ->
        min = range.min
        if @min < min
            min = @min

        max = range.max
        if @max > max
            max = @max

        result = new Range(min, max)
        result.array = @array.concat(range.array)
        return result

    toString: ->
        return "#{@min}-#{@max}"
