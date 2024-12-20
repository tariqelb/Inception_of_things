#!/bin/bash

# HTML content array
HTML=(
"<!DOCTYPE html><html><head><title>Welcome to nginx!</title></head><body><h1>Welcome to nginx!</h1><h2>This is app 1 a</h2><p><em>Thank you for using nginx.</em></p></body></html>"
"<!DOCTYPE html><html><head><title>Welcome to nginx!</title></head><body><h1>Welcome to nginx!</h1><h2>This is app 1 b</h2><p><em>Thank you for using nginx.</em></p></body></html>"
"<!DOCTYPE html><html><head><title>Welcome to nginx!</title></head><body><h1>Welcome to nginx!</h1><h2>This is app 1 c</h2><p><em>Thank you for using nginx.</em></p></body></html>"
"<!DOCTYPE html><html><head><title>Welcome to nginx!</title></head><body><h1>Welcome to nginx!</h1><h2>This is app 2</h2><p><em>Thank you for using nginx.</em></p></body></html>"
"<!DOCTYPE html><html><head><title>Welcome to nginx!</title></head><body><h1>Welcome to nginx!</h1><h2>This is app 3</h2><p><em>Thank you for using nginx.</em></p></body></html>"
)

# Get the list of pod names (one per line)
podsname=$(kubectl get pods -o name)

# Initialize index to 0
index=0

# Loop through each pod name
echo "$podsname" | while IFS= read -r pod; do
	# Get the current HTML content based on the index
	currentHTML="${HTML[$index]}"
	echo $pod
	# Execute the echo command inside the container and overwrite index.html
	kubectl exec "$pod" -- bash -c "echo '$currentHTML' > /usr/share/nginx/html/index.html"
	kubectl exec "$pod" -- bash -c "cat /usr/share/nginx/html/index.html"
	kubectl exec "$pod" -- bash -c "nginx -s reload"

	# Increment index
	((index++))
done

