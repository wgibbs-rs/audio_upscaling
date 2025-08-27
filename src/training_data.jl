module Data

using JSON
using WAV

mutable struct Context
    music::Vector{String}
    music_section::String
    sfx::Vector{String}
    sfx_section::String
    nature::Vector{String}
    nature_section::String
    iteration::Int
    Context() = new(
        String[],
        "",
        String[],
        "",
        String[],
        "",
        1
    )
end

ctx::Context = Context()

"""
Initialize the program to later download each link and process its audio.
Unwrap links.json, and store each variable in an array.
"""
function Init()
    contents = read("links.json", String)
    data = JSON.parse(contents)

    ctx.music = data["music"]
    ctx.music_section = data["section"][1]
    ctx.sfx = data["sfx"]
    ctx.sfx_section = data["section"][2]
    ctx.nature = data["nature"]
    ctx.nature_section = data["section"][3]
end

"""
Download and process the next audio file. Then, save each PCM signal to 
high_quality_version.wav. This will then be read by Python.

Audio files will be downloaded, processed, and saved. Then, the function
will return true of false, depending on success, triggering Python to 
continue.
"""
function Iter()

    # Create a directory to store this file
    try
        run("mkdir tmp")
    catch e
        println("Unable to download file: $e")
        exit()
    end

    # Download the file with yt-dlp
    try 
        if iterations ≤ length(ctx.music)
            run("""
            yt-dlp \
            --download-sections "*$(ctx.music_section)"
            -x \
            --audio-format wav \
            --audio-quality 0 \
            -o "tmp/original.wav" \
            -y \
            $(ctx.music[ctx.iteration])
            """)
        elseif iterations ≤ length(ctx.music) + length(ctx.sfx)
            run("""
            yt-dlp \
            --download-sections "*$(ctx.sfx_section)" \
            -x \
            --audio-format wav \
            --audio-quality 0 \
            -o "tmp/original.wav" \
            -y \
            $(ctx.sfx[ctx.iteration - length(ctx.music)])
            """)
        elseif iterations ≤ length(ctx.music) + length(ctx.sfx) + length(ctx.nature)
            run("""
            yt-dlp \
            --download-sections "*$(ctx.nature_section)" \
            -x \
            --audio-format wav \
            --audio-quality 0 \
            -y \
            -o "tmp/original.wav" \
            $(ctx.nature[ctx.iteration - length(ctx.music) - length(ctx.sfx)])
            """)
        else 
            return false
        end
    catch e
        println("Unable to download file: $e")
        exit()
    end

    # Create the 44.1k version of the audio file
    try 
        run("ffmpeg -i tmp/original.wav -ar 44100 -y tmp/high_quality_version.wav")
    catch e
        println("Unable to download file: $e")
        exit()
    end

    # Iterate so we can access the next video
    ctx.iteration += 1

end

end # module Data
