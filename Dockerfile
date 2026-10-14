FROM python:3.15@sha256:16e7e5fc4e79fe153c818ac9b46595c7addddaad744d49595377836e300ad1c6 as Builder
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 install --upgrade pip  # enable PEP 660 support
WORKDIR /app
# install libGL.so.1
RUN apt-get update && apt-get install libgl1 -y
# install BMTools
RUN git clone https://github.com/OpenBMB/BMTools.git --depth=1
RUN cd BMTools && \
    pip install -r requirements.txt && \
    python setup.py develop
# install AgentVerse
WORKDIR /app/AgentVerse
COPY requirements*.txt ./
RUN pip install -r requirements.txt
RUN pip install -r requirements_local.txt
COPY . .
RUN pip install -e .
