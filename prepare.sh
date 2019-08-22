#!/bin/sh

if [ ! -f "./.bin/k3s" ]; then
  mkdir -p ./.bin
  curl -L https://github.com/rancher/k3s/releases/download/v0.8.1/k3s -o ./.bin/k3s
  chmod +x ./.bin/k3s
fi

cat > ./.envrc <<'EOL'
export_function() {
  local name=$1
  local alias_dir=$PWD/.direnv/aliases
  mkdir -p "$alias_dir"
  PATH_add "$alias_dir"
  local target="$alias_dir/$name"
  if declare -f "$name" >/dev/null; then
    echo "#!$SHELL" > "$target"
    declare -f "$name" >> "$target" 2>/dev/null
    echo "$name \$*" >> "$target"
    chmod +x "$target"
  fi
}

kubectl() {
  bin_path=$PWD
  while [[ "$bin_path" != "" && ! -e "$bin_path/.bin" ]]; do
    bin_path=${bin_path%/*}
  done

  cfg_path=$PWD
  while [[ "$cfg_path" != "" && ! -f "$cfg_path/kubeconfig" ]]; do
    cfg_path=${cfg_path%/*}
  done

  $bin_path/.bin/k3s kubectl --kubeconfig=$cfg_path/kubeconfig $*
}

export_function kubectl
EOL

direnv allow
