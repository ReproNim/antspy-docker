FROM python:3.10-slim-buster
HEALTHCHECK NONE

RUN apt-get update && \
    apt-get install -y build-essential cmake libpng-dev pkg-config git

RUN useradd --create-home --shell /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

COPY requirements.txt .
RUN pip install -r requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/home/dockeruser/.local/bin"

RUN mkdir input
RUN mkdir output

RUN python3 -c 'import ants; import antspyt1w; antspyt1w.get_data(  force_download=True )'
RUN python3 -c 'import ants; import antspymm; antspymm.get_data(  force_download=True )'
RUN python3 -c 'import ants; import antspyt1w; img=ants.image_read("~/.antspyt1w/28364-00000000-T1w-00.nii.gz"); antspyt1w.hierarchical( img, "/tmp/XXX", labels_to_register=None, is_test=True)'

