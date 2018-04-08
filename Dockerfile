FROM alpine:3.7 AS builder

RUN apk --no-cache add python3
RUN python3 -m venv /app

COPY requirements.txt /requirements.txt
RUN /app/bin/pip install -r requirements.txt

COPY setup.py /src/setup.py
COPY hpfeeds /src/hpfeeds
RUN /app/bin/pip install /src


FROM alpine:3.7

RUN apk --no-cache add sqlite python3

COPY --from=builder /app /app

RUN mkdir /app/var
WORKDIR /app/var
VOLUME /app/var

EXPOSE 20000

CMD ["/app/bin/python", "-m", "hpfeeds.scripts.broker"]
