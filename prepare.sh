#!/bin/sh

if [ ! -f "./.bin/kubectl" ]; then
  case "$OSTYPE" in
    darwin*) os="darwin" ;;
    *)       os="linux"  ;;
  esac
  case $(uname -m) in
    arm64) arch="arm64" ;;
    *)     arch="amd64" ;;
  esac

  mkdir -p ./.bin
  curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/$os/$arch/kubectl -o ./.bin/kubectl
  chmod +x ./.bin/kubectl
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

  ns_path=$PWD
  while [[ "$ns_path" != "" && ${ns_path##*/} != "ns-"* ]]; do
    ns_path=${ns_path%/*}
  done

  ns=${ns_path##*/}
  if [[ "$ns" == "" ]]; then
    ns="default"
  fi

  $bin_path/.bin/kubectl --kubeconfig=$cfg_path/kubeconfig --namespace=${ns/ns-/} $*
}

export_function kubectl

export SOPS_PGP_FP="1d1a32d148edf1e8a536f7a08a82a50a2df52ee4"
EOL

direnv allow
