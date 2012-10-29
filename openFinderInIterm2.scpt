-- Opens a new iTerm tab set to the current Finder window.
-- Especially useful with Quicksilver and a Finder-specific hotkey like
-- Command-T.

-- Base code:
-- http://jots.mypopescu.com/post/9117847341/open-iterm2-terminal-in-current-folder

on run {input, parameters}
    tell application "Finder"
        set sel to selection
        -- always select the current Finder window, regardless of selection
        if (count window) > 0 then
            set myTarget to target of window 1
        else
            set myTarget to path to home folder
        end if
        my openTerminal(myTarget)
    end tell

end run

on openTerminal(location)
    set location to location as alias
    set the_path to POSIX path of location
    repeat until the_path ends with "/"
        set the_path to text 1 thru -2 of the_path
    end repeat

        -- modified to use the fishfish shell instead of bash
    set cmd to "cd " & quoted form of the_path & " ; and ls"

    tell application "System Events" to set terminalIsRunning to exists application process "iTerm"

    tell application "iTerm"
        activate

        if terminalIsRunning is true then
            -- set NewTerminal to (make new terminal)
            tell the current terminal
                launch session "Default"
                set _session to current session
                tell _session
                    write text cmd
                end tell
            end tell
        else
            tell the current terminal
                tell the current session
                    write text cmd
                end tell
            end tell
        end if
    end tell
end openTerminal
