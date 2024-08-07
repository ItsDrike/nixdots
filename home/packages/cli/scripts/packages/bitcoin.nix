{pkgs, ...}: (pkgs.writeShellApplication {
  name = "bitcoin";
  runtimeInputs = with pkgs; [coreutils curl jq];
  text = ''
    #!/bin/sh

    BTC_DATA=$(curl https://api.coindesk.com/v1/bpi/currentprice.json 2>/dev/null || echo 'ERR')

    if [ "$BTC_DATA" != "ERR" ]; then
        BTC_PRICE=$(echo "$BTC_DATA" | jq -r ".bpi.USD.rate_float")
        BTC_PRICE=$(printf "%.0f" "$BTC_PRICE")
        echo \$"$BTC_PRICE"
    else
        echo "N/A"
    fi
  '';
})
