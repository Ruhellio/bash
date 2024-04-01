#!/bin/bash
function adding_pipeline() {
read -p "Enter the name of a pipeline"$'\n' name
mkdir /etc/logstash/conf.d/$name
printf "\n- pipeline.id: %s\n  path.config: '/etc/logstash/conf.d/%s/*.conf'" $name $name >> /etc/logstash/pipelines.yml
}
function testing() {
/usr/share/logstash/bin/logstash -f $path
read -p "Hit any button to go to the main menu" button
if [[$button]]; then
main_menu
fi
}
function restarting() {
if ! [[ `ps -aux | grep "logstash"  | cut -d " " -f 1` =~ "logstash" ]]; then
echo "Logstash is not running. Check the configuration"
sleep 2
main_menu
else
systemctl stop logstash && systemctl start logstash
while true
do
for x in `seq 1 1024`; do
printf "."
done
if [[ `systemctl status logstash` =~ "running" ]]; then
echo "Logstash restarted & active"
main_menu
fi
done
fi
}
function main_menu() {
if [[ $EUID -ne 0 ]]; then
    echo "Are you ROOT? This script must be run as ROOT"
    exit 1
else

echo "╔╗──╔══╗╔═══╗╔══╗╔════╗╔══╗╔══╗╔╗╔╗╔═══╗╔═══╗"
echo "║║──║╔╗║║╔══╝║╔═╝╚═╗╔═╝║╔╗║║╔═╝║║║║║╔══╝║╔═╗║"
echo "║║──║║║║║║╔═╗║╚═╗──║║──║╚╝║║╚═╗║╚╝║║╚══╗║╚═╝║"
echo "║║──║║║║║║╚╗║╚═╗║──║║──║╔╗║╚═╗║║╔╗║║╔══╝║╔╗╔╝"
echo "║╚═╗║╚╝║║╚═╝║╔═╝║──║║──║║║║╔═╝║║║║║║╚══╗║║║║"
echo "╚══╝╚══╝╚═══╝╚══╝──╚╝──╚╝╚╝╚══╝╚╝╚╝╚═══╝╚╝╚╝"
echo $'\n'
echo $'\n'
echo "----------------------------------------"
echo "[  1  ] Restart logstash"
echo "[  2  ] Run with a config"
echo "[  3  ]                 "
echo "[  4  ] Add a new pipeline to /logstash/pipelines.yml"
echo "[  5  ] Just stop logstash. And that's all"
echo "[  6  ] EXIT"
echo "----------------------------------------"
read -p "[ »»» ] Enter the number of option [1-6]:"$'\n' option
case $option in
1)
echo "Logstash will be restarted"
sleep 5
restarting
;;
2)
echo "Enter full path to a config file:"$'\n' path
read -p ">_ " path
testing $path
;;
4)
adding_pipeline
;;
5)
systemctl stop logstash
;;
6)
echo "See you!"
sleep 1
exit
;;
*)
echo "Not a valid choise [1-6]"
sleep 2
clear
;;
esac
fi
}
while true
do
main_menu
done
