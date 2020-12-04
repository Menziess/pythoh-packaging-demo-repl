FROM python:3.8

COPY dist/* .

RUN pip install *.whl
RUN rm *.whl

ENTRYPOINT ["fibo"]
