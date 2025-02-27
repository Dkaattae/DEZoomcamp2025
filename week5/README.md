# pyspark   
## local setup   
I setup pyspark in docker container.    
Run docker in command line   
```docker build -t pyspark .```   
```
docker run -it \
	-p 8888:8888 \
	-p 4040:4040 \
	-v $(pwd):/app \
	pyspark
```   

inside the dockerfile, I installed openjdk version 17. note, openjdk has to be version 17 for pyspark.    
and pyspark, python3. after basic installation, I pip installed requried packages for python. see requirement.txt.   
then I exposed port 4040 for spark master UI, and 8888 for jupyter notebook.   
then setup entrypoint to run jupyter notebook.   
after running docker run command line, there will be a jupyter notebook url, start with '127.0.0.1:8888/'. copy that url and paste to brower will see jupyter notebook.   
after spark instance created, go to localhost:4040 in browser will see the spark master UI.   

## spark basic
spark_sql.ipynb and spark_groupby_join.ipynb running content from video.   

## homework   
homework.ipynb running content for homework.   
