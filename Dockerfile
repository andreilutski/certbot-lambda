FROM public.ecr.aws/lambda/python:3.10

RUN yum install -y zip
RUN pip3.10 install virtualenv
RUN cd; \
  virtualenv venv; \
  source venv/bin/activate; \
  pip install certbot certbot-dns-route53 raven; \
  cd venv/lib/python3.10/site-packages; \
  zip -r ~/certbot-$(certbot --version | cut -d " " -f 2).zip .
RUN echo Zip file created in $(ls ~/certbot-*.zip)
