FROM ubuntu:18.04
RUN apt-get update && apt-get install \
  -y --no-install-recommends python3 python3-virtualenv

# Fix locale for python
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/'        /etc/locale.gen \
 && sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen
 
# Setup virtualenv for python
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy files and folders
WORKDIR /
COPY app.py job.py update.py start.sh start.sh ./
ADD static/ /static/
ADD public/ /public/
ADD notebooks/ /notebooks/
ADD data/ /data/
RUN mkdir insights

# Run app
RUN ["chmod", "+x", "./start.sh"]
CMD ./start.sh
