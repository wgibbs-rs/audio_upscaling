module Data

using JSON
using WAV

mutable struct Context
    music::Vector{String}
    sfx::Vector{String}
    environment::Vector{String}
    iteration::Int
    Context() = new(
        String[],
        String[],
        String[],
        0
    )
end

ctx::Context = Context()

"""
Initialize the program to later download each link and process its audio.
Unwrap links.json, and store each variable in an array.
"""
function Init()

end

"""
Download and process the next audio file. Then, save each PCM signal to 
high_quality.wav and low_quality.wav. This will then be read by Python.

Audio files will be downloaded, processed, and saved. Then, the function
will return void, triggering Python to continue.
"""
function Iter()

    # Download the file with yt-dlp
    try 
        if iterations < length(ctx.music)
            run("yt-dlp --download-sections \"$(ctx.music[0])\" -x --audio-format wav $(ctx.music[ctx.iteration])")
        elseif iterations < length(ctx.music) + length(ctx.sfx)
            run("yt-dlp --download-sections \"$(ctx.sfx[0])\" -x --audio-format wav $(ctx.sfx[ctx.iteration])")
        else
            run("yt-dlp --download-sections \"$(ctx.environment[0])\" -x --audio-format wav $(ctx.environment[ctx.iteration])")
        end
    catch e
        println("Unable to download file: $e")
    end

end

end # module Data
