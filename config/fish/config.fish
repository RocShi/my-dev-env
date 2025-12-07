if status is-interactive
    # Commands to run in interactive sessions can go here
    ## cancel the greeting
    set -g fish_greeting ""
    
    ## source your bash scripts, such as ROS2: source_bash /opt/ros/humble/setup.bash
    
    ## init starship prompt
    # if command -v starship >/dev/null 2>&1
    #     eval "$(starship init fish)"
    # end
end
