if status is-interactive
    # Commands to run in interactive sessions can go here
    ## cancel the greeting
    set -g fish_greeting ""
    ## source your bash scripts, such as ROS2: source_bash /opt/ros/humble/setup.bash
end
