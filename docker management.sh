#!/bin/bash

# 显示菜单选项
show_menu() {
    echo "Docker 容器管理"
    echo "1. 列出所有容器"
    echo "2. 启动指定容器"
    echo "3. 停止指定容器"
    echo "4. 删除指定容器"
    echo "5. 启动所有停止的容器"
    echo "6. 停止所有运行中的容器"
    echo "7. 重启所有容器"
    echo "8. 删除所有停止的容器"
    echo "9. 退出"
}

# 列出所有容器并用数字排列
list_containers() {
    containers=$(docker ps -a --format "{{.ID}} - {{.Names}} - {{.Status}}")
    if [ -z "$containers" ]; then
        echo "没有找到容器。"
    else
        echo "$containers" | nl -w 2 -s '. ' # 使用nl命令对输出进行数字编号
    fi
    pause
}

# 暂停并提示按任意键继续
pause() {
    read -p "按任意键返回菜单..."
}

# 启动指定容器
start_specific_container() {
    if list_containers; then
        read -p "请输入要启动的容器序号: " container_num
        container_id=$(docker ps -a --format "{{.ID}}" | sed -n "${container_num}p")
        if [ -n "$container_id" ]; then
            docker start "$container_id"
            echo "容器 $container_id 已启动。"
        else
            echo "无效的容器序号。"
        fi
    fi
    pause
}

# 停止指定容器
stop_specific_container() {
    if list_containers; then
        read -p "请输入要停止的容器序号: " container_num
        container_id=$(docker ps -a --format "{{.ID}}" | sed -n "${container_num}p")
        if [ -n "$container_id" ]; then
            docker stop "$container_id"
            echo "容器 $container_id 已停止。"
        else
            echo "无效的容器序号。"
        fi
    fi
    pause
}

# 删除指定容器
remove_specific_container() {
    if list_containers; then
        read -p "请输入要删除的容器序号: " container_num
        container_id=$(docker ps -a --format "{{.ID}}" | sed -n "${container_num}p")
        if [ -n "$container_id" ]; then
            docker rm "$container_id"
            echo "容器 $container_id 已删除。"
        else
            echo "无效的容器序号。"
        fi
    fi
    pause
}

# 启动所有停止的容器
start_containers() {
    echo "启动所有停止的容器："
    docker start $(docker ps -a -q --filter "status=exited")
    pause
}

# 停止所有运行中的容器
stop_containers() {
    echo "停止所有运行中的容器："
    docker stop $(docker ps -q)
    pause
}

# 重启所有容器
restart_containers() {
    echo "重启所有容器："
    docker restart $(docker ps -a -q)
    pause
}

# 删除所有停止的容器
remove_stopped_containers() {
    echo "删除所有停止的容器："
    docker rm $(docker ps -a -q --filter "status=exited")
    pause
}

# 主逻辑
while true; do
    show_menu
    read -p "请选择操作 [1-9]: " choice
    case $choice in
        1) list_containers ;;
        2) start_specific_container ;;
        3) stop_specific_container ;;
        4) remove_specific_container ;;
        5) start_containers ;;
        6) stop_containers ;;
        7) restart_containers ;;
        8) remove_stopped_containers ;;
        9) echo "退出"; exit 0 ;;
        *) echo "无效选项，请重试。" ;;
    esac
done
