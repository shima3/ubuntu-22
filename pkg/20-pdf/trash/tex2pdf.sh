#!/bin/bash
paper="$1"
# latex=uplatex
# latex=lualatex
# -file-line-error エラーメッセージが「ファイル名:行番号:エラー内容」になる。
# -halt-on-error エラーが発生したら停止する。
# -shell-escape 任意の外部プログラムをTeXから実行できるようにする。
# --no-guess-input-enc --kanji=utf8 自動判定を無効にし、文字コードをutf8とする。
export LC_CTYPE="ja_JP.UTF-8"
latex="platex -file-line-error -halt-on-error -shell-escape --no-guess-input-enc --kanji=utf8"
if $latex $paper
then
    if $latex $paper
    then
        # dvipdfmx -f ipa.map -E $paper
        if dvipdfmx $paper
        then pdffonts $paper.pdf
        fi
    fi
fi
