FROM python:3.8-alpine

COPY dist/* .

RUN pip install *.whl
RUN rm *.whl

ENTRYPOINT ["fibo"]
