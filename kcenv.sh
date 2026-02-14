kcenv() {
  local service="devenv-$1"
  [ -z "$service" ] && { echo "usage: kcenv <service>"; return 2; }

  local b64 blob
  b64="$(security find-generic-password -s "$service" -a "$USER" -w 2>/dev/null)" \
    || { echo "❌ no Keychain item for service='$service'"; return 1; }

  # macOS base64 decode flag is -D
  blob="$(printf '%s' "$b64" | base64 -D 2>/dev/null)" \
    || { echo "❌ base64 decode failed (was the item stored with kc_env_store_b64?)"; return 1; }

  echo $blob
  # Parse dotenv lines: KEY=VALUE, skip blanks and #comments, strip one layer of quotes
  while IFS= read -r line || [ -n "$line" ]; do
    # trim
    line="${line#"${line%%[![:space:]]*}"}"; line="${line%"${line##*[![:space:]]}"}"
    [ -z "$line" ] && continue
    case "$line" in \#*) continue;; esac

    key=${line%%=*}
    val=${line#*=}

    # trim key
    key="${key%"${key##*[![:space:]]}"}"; key="${key#"${key%%[![:space:]]*}"}"

    # strip one layer of quotes
    case "$val" in
      \"*\") val=${val#\"}; val=${val%\"};;
      \'*\') val=${val#\'}; val=${val%\'};;
    esac

    # remove inline comment if unquoted
    if [[ "$val" != *\"* && "$val" != *\'* ]]; then
      val="${val%%#*}"
      val="${val%"${val##*[![:space:]]}"}"
    fi

    [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] && export "$key=$val"
  done <<< "$blob"
  
  echo "✅ exported env vars from Keychain service='$1'"
}
  
  
kclist() {
  security dump-keychain |
  grep '"svce"' |
  grep -E '"svce"<blob>="devenv-' |
  sed 's/.*"svce"<blob>="devenv-//; s/".*//'   
}

    
kcdel() {
  local service="devenv-$1"
  [ -z "$service" ] && { echo "usage: kcdel <service>"; return 2; }
  security delete-generic-password -s $service -a "$USER"
}

    
