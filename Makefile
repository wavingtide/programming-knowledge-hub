commit_and_push:
	git add .
	git commit -m "Last Sync: $(date "+%Y-%m-%d %H:%M:%S")"
	git push
