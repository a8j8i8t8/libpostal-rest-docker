FROM ubuntu:16.04

ARG COMMIT
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    autoconf automake build-essential curl git libsnappy-dev libtool pkg-config

RUN git clone https://github.com/openvenues/libpostal -b $COMMIT

COPY ./*.sh /libpostal/

USER nobody
RUN chown -R nobody:nobody /libpostal
RUN chmod +x /libpostal/build_libpostal.sh
RUN chmod +x /libpostal/build_libpostal_rest.sh

WORKDIR /libpostal
RUN ./build_libpostal.sh
RUN ./build_libpostal_rest.sh

EXPOSE 8080

CMD /libpostal/workspace/bin/libpostal-rest
