#!/bin/sh

find . -name '*.wav' | while read i ; do
    BASE="$(dirname "$i")/$(basename "$i" .wav)"
    TITLE="$(basename "$i")"

    [ "$i" -nt "$BASE.mp3" ] && lame -b 32 -V 5 -q 5 -m j "$i" "$BASE.mp3" --tt "$TITLE" --ta "j. shagam @ metronomic.tk" --tl "Global Game Jam 2016" --ty 2016
    [ "$i" -nt "$BASE.ogg" ] && oggenc "$i" -o "$BASE.ogg" -t "$TITLE" -a "j. shagam @ metronomic.tk"
    [ "$i" -nt "$BASE.flac" ] && flac "$i" -fo "$BASE.flac"
done

(
cat "template/head.html"

find . -type f -name '*.wav' | while read wav ; do
    printf '%d %s\n' $(stat -f %m "$wav") "$wav"
done | sort -nr | while read mtime wav ; do
    echo mtime=$mtime wav=$wav 1>&2
    dir="$(dirname "$wav" | cut -f2- -d/)"
    basename="$(basename "$wav" .wav)"
    pathpart="$(dirname "$wav")/$basename"
    fmtime="$(stat -t "%Y-%m-%d %H:%M" -f %Sm "$wav")"
    printf '<tr>
    <td><a href="%s">%s</a></td>
    <td>%s</td>
    <td>%s</td>
    <td><a href="%s.mp3">mp3</a></td>
    <td><a href="%s.ogg">ogg</a></td>
    <td><a href="%s.flac">flac</a></td>
    <td>%s</td>
    </tr>' "$dir" "$dir" "$basename" "$(soxi -d "$wav")" "$pathpart" "$pathpart" "$pathpart" "$fmtime"
done
printf '</table>'

cat "template/foot.html"
) > index.html
