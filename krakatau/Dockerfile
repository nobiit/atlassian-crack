FROM python:2

RUN pip install pyinstaller==3.6

WORKDIR /app
RUN git clone https://github.com/Storyyeller/Krakatau . && \
    git checkout master

RUN pyinstaller --distpath /dist/ assemble.py --onefile && \
    pyinstaller --distpath /dist/ disassemble.py --onefile

FROM ubuntu
COPY --from=0 /dist/ /usr/local/bin/
