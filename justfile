default:
  @just --list

# Docker containers on macOS
# brew install --cask docker

# Define default values for parameters

image_name := "app_ce"
tag := "latest"
container_name := "app_container"
host_port := "8080"
container_port := "8080"
dockerfile := "Dockerfile"
build_context := "."

# Commands

update-st-config:
    streamlit config show > .streamlit/config.toml

app app_name="src/Camino_-_Who_was_St_James?.py":
    streamlit run {{app_name}} --server.address=localhost


reqs:
    pdm export --o requirements.txt --without-hashes --prod


translate-md target_dir="." languages="en":
    python src/batch_translate_md.py --target_dir {{target_dir}} --languages {{languages}}


lint inpath outfile:
    pymarkdownlnt -d md013,md041 scan -r {{ inpath }} > {{ outfile }}

# Docker

dbuild:
    docker build -t {{image_name}}:{{tag}} -f {{dockerfile}} {{build_context}}

drun:
    docker run --name {{container_name}} -p {{host_port}}:{{container_port}} -d {{image_name}}:{{tag}}

drun_camino:
    docker run --name {{container_name}} -e ACTIVE_APP=src/Camino.py -p {{host_port}}:{{container_port}} -d {{image_name}}:{{tag}}

dstop:
    docker stop {{container_name}}

dremove:
    docker rm {{container_name}}

dlogs:
    docker logs {{container_name}}

dshell:
    docker exec -it {{container_name}} /bin/sh

dpush:
    docker push {{image_name}}:{{tag}}

dpull:
    docker pull {{image_name}}:{{tag}}
