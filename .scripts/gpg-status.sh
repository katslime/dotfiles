gpg --card-status &> /dev/null;
if [ $? -eq 0 ]; then
	user="%{F#4A4A4A}%{F-} $(gpg --card-status | grep "Login data" | awk '{print $NF}')";
else
	user="%{F#4A4A4A}%{F-} disconnected"
fi

echo $user
