up: rm
	docker build -t myapp_image .
	docker run  --rm -p 8080:8080 -d --name myapp myapp_image

rm:
	docker rm -f myapp

tail:
	docker exec myapp bash -c 'tail -f /var/log/supervisor/*'