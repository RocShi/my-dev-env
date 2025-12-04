function source_bash
    if test -f $argv[1]
        # 使用 while read -z 来安全读取 null 分隔的 env 输出
        bash -c "source $argv[1] > /dev/null 2>&1 && env -0" | while read -z line
            set -l item (string split -m 1 = $line)
            if test (count $item) -eq 2
                if not contains $item[1] _ SHLVL PWD HOME USER TERM
                    if string match -q "*PATH" $item[1]
                        set -gx $item[1] (string split : $item[2])
                    else
                        set -gx $item[1] $item[2]
                    end
                end
            end
        end
    end
end
