#! /bin/bash

cfile=${XDG_CONFIG_HOME:-$HOME/.config}/weather.conf
wfile=${XDG_CACHE_HOME:-$HOME/.cache}/weather.json
export cfile wfile

declare -A icons=([i01d]=weather-clear [i01n]=weather-clear-night [i02d]=weather-few-clouds [i02n]=weather-few-clouds-night
                  [i03d]=weather-overcast [i03n]=weather-overcast [i04d]=weather-severe-alert [i04n]=weather-severe-alert
                  [i09d]=weather-showers [i09n]=weather-showers [i10d]=weather-showers-scattered [i10n]=weather-showers-scattered
                  [i11d]=weather-storm [i11n]=weather-storm [i13d]=weather-snow [i13n]=weather-snow [i50d]=weather-fog [i50n]=weather-fog)
export sicons=$(declare -p icons)

export URI="https://openweathermap.org/"
export APIKEY="A9fcb0683b9a9a8d43539e4f6fc397ff"
export CITY="Markham"
export COUNTRY="Canada"
export UNITS="metric"

# create pipe for communicate with tray icon
export FIFO=$(mktemp -u --tmpdir XXXXXXXX.weather.fifo)
mkfifo $FIFO
trap "rm -rf $FIFO" EXIT
exec 3<> $FIFO

function wthr_update {
    source $cfile
    eval $sicons

    if [[ -z $APIKEY ]]; then
        echo "API key missing" > /dev/stderr
        return
    fi

    LNG=${LANG%_*}

    mkdir -p $(dirname $wfile)
    curl -s -o $wfile "http://api.openweathermap.org/data/2.5/weather?q=${CITY},${COUNTRY}&APPID=${APIKEY}&units=${UNITS}&lang=${LNG:-en}"
    [[ $? -eq 0 ]] || return

    printf -v temp "%.f°C" $(jq '.main.temp' $wfile)
    i="i$(jq -r '.weather[0].icon' $wfile)"

    echo -e "icon:${icons[$i]}\ntooltip:Current temp - $temp" > $FIFO
}
export -f wthr_update

function wthr_config {
    source $cfile

    case $UNITS in
        imperial) ulist="metric!^imperial!standard" ;;
        standard) ulist="metric!imperial!^standard" ;;
        *) ulist="^metric!imperial!standard" ;;
    esac

    res=($(yad --title="Weather configuration" --window-icon=settings \
               --separator=" " --form \
               --field="API key:" "$APIKEY" \
               --field="Country code:" "$COUNTRY" \
               --field="City:" "$CITY" \
               --field="Units::CB" "$ulist" \
               --field="Period::NUM" "${PERIOD:-600}"))

    if [[ -n $res ]]; then
        cat <<EOF > $cfile
APIKEY=${res[0]}
COUNTRY=${res[1]}
CITY=${res[2]}
UNITS=${res[3]}
PERIOD=${res[4]}
EOF
    fi
}
export -f wthr_config

function wthr_show {
    eval $sicons

    printf -v temp "%.f°C" "$(jq -r '.main.temp' $wfile)"
    printf -v fl_temp "%.f°C" "$(jq -r '.main.feels_like' $wfile)"
    i="i$(jq -r '.weather[0].icon' $wfile)"
    state="$(jq -r '.weather[0].description' $wfile)"
    city="$(jq -r '.name' $wfile)"
    wspeed="$(jq -r '.wind.speed' $wfile)"
    wdeg="$(jq -r '.wind.deg' $wfile)"
    hum="$(jq -r '.main.humidity' $wfile)"
    press="$(jq -r '.main.pressure' $wfile)"
    sr="$(jq -r '.sys.sunrise' $wfile)"
    ss="$(jq -r '.sys.sunset' $wfile)"

    if [[ $wdeg -ge 349 || $wdeg -le 11 ]]; then
        wdir="N"
        warrow='↓'
    elif [[ $wdeg -le 79 ]]; then
        wdir="NE"
        warrow='↙'
    elif [[ $wdeg -le 124 ]]; then
        wdir="E"
        warrow='←'
    elif [[ $wdeg -le 169 ]]; then
        wdir="SE"
        warrow='↖'
    elif [[ $wdeg -le 214 ]]; then
        wdir="S"
        warrow='↑'
    elif [[ $wdeg -le 259 ]]; then
        wdir="SW"
        warrow='↗'
    elif [[ $wdeg -le 304 ]]; then
        wdir="W"
        warrow='→'
    else
        wdir="NW"
        warrow='↘'
    fi

    fsr=$(date -d @$sr +'%H:%M:%S')
    fss=$(date -d @$ss +'%H:%M:%S')

    TEXT="Weather in <b>$city</b>\n\n"
    TEXT+="$temp (<i>feels like</i> $fl_temp), $state\n\n"
    TEXT+="Wind: $wspeed m/s ($wdir $warrow)\nHumidity: ${hum}%\nPressure: $press hPa\n\n"
    TEXT+="Sunrise: $fsr\nSunset: $fss"

    yad --title="Weather" --window-icon=sunny --width=420 --height=150 \
        --posx=-100 --posy=50 --borders=10 --image="${icons[$i]}" --text="$TEXT" \
        --button="Forecast!web-browser:xdg-open $URI" --button=yad-close
}
export -f wthr_show

# make sure config exists and load it
mkdir -p $(dirname $cfile)
touch $cfile
source $cfile

yad --notification --listen --use-interp --image=weather-clear-night --command="wthr_show" \
    --menu="Update!wthr_update|Configuration!wthr_config|Exit!quit" <&3 &
PID=$!

# main loop
wthr_update
while : ; do
    for ((i=0; i<$PERIOD; i=i+2)); do
        kill -0 $PID &> /dev/null || exit 0
        sleep 2
    done
    wthr_update
done
