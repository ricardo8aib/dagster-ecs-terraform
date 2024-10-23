# Call Python script and specific functions

deploy_base_infrastructure:
	python3 utils/make.py deploy_base_infrastructure

build_and_push:
	python3 utils/make.py build_and_push

deploy_ecs_services:
	python3 utils/make.py deploy_ecs_services

destroy_ecs_services:
	python3 utils/make.py destroy_ecs_services

destroy_everything:
	python3 utils/make.py destroy_everything
