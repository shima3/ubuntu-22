#!/bin/bash
img="$1"

if [ "$img" == "" ]; then
    echo 'Usage: pull.sh IMAGE'
    exit 0
fi

# REMOTE_CREATED=$(docker manifest inspect "$img" | jq -r '.manifests[0].digest' | xargs -I {} docker image inspect {} --format '{{.Created}}' 2>/dev/null || echo "not_found")
REMOTE_CREATED="$(skopeo inspect docker://$img 2> /dev/null | jq --raw-output '.Created' || echo not_found)"
LOCAL_CREATED=$(docker image inspect "$img" --format '{{.Created}}' 2> /dev/null || echo "not_found")

if [ "$REMOTE_CREATED" == "not_found" ]; then
    echo "リモートイメージ情報を取得できませんでした。"
elif [ "$LOCAL_CREATED" == "not_found" ]; then
    echo "ローカルイメージが存在しません。pull します。"
    docker pull "$img"
elif [[ "$REMOTE_CREATED" > "$LOCAL_CREATED" ]]; then
    echo "リモートの方が新しいため更新します。"
    docker pull "$img"
else
    echo "ローカルの方が新しい、または同じため更新しません。"
fi
