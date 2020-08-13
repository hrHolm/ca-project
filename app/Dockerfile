FROM python:rc-alpine
WORKDIR /project
ADD ../ /project
RUN pip install -r ../requirements.txt
ENTRYPOINT ["python"]
CMD ["run.py"]