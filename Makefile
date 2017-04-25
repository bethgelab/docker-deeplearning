build-test:
	docker build -t bethgelab/deeplearning-test deeplearning

test: build-test
	pytest tests
	#docker run -it bethgelab/deeplearning-test echo "hello as root"
	#agmb-docker run -it bethgelab/deeplearning-test echo "hello as local user"

output_watch:
	find deeplearning tests -print | grep -v "tests/.*.pyc" | grep -v ".*.swp"

watch_test:
	find deeplearning tests -print | grep -v "tests/.*.pyc" | grep -v ".*.swp" | entr make test
