#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash efibootmgr
delete_num() {
  for num in $1;do
    echo ""
    read -r -p "delete ${boot[$num]}?(y/n)" choice
    if [[ "$choice" == [Yy] ]]; then
      efibootmgr -q -B -b "${bootnums[$num]}" || exit
    fi
  done
}
while true; do
  echo "loading..."
  items=$(efibootmgr)
  readarray -t boot <<< "$(echo "$items" | grep -e 'Boot[0-9]*[A-F]*\*')"
  for ((i=0;i<${#boot[@]};i=i+1)); do
    echo "$i: ${boot[$i]}"
  done
  readarray -t bootnums <<< "$(echo "$items"| awk '{print $1}' | grep -e 'Boot[0-9]*[A-F]*\*' | sed 's/Boot//' | sed 's/\*//')"
  read -r -p "To be deleted(,):" delete
  clear
  readarray -td, dels <<< "$delete"
  for i in "${dels[@]}"; do
    toDel=$(eval echo "$i")
    delete_num "$toDel"
  done
done
