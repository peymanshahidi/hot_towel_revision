# Notes 
Recent [Google Docs](https://docs.google.com/document/d/19VKawNqdkLPXtTQgfj_SvqiI3xrdZCv4S6MUOhah-nA/edit)

# Run on Docker 
Running the code in a Docker container has some nice advantages, particularly with respect to package dependencies and minimizing mac/linux differences. From the `hot_towel` directory, run: 
```
sudo docker build -t hot_towel .
```
This creates a docker image: 
```
puddler: hot_towel (master) $ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hot_towel           latest              e537fe1a6e14        19 minutes ago      11.4GB
ubuntu              latest              452a96d81c30        3 weeks ago         79.6MB
```

To access interactively, 
```
sudo docker run -it hot_towel
```

To get running (but not to enter the shell): 
```
 sudo docker run --name hot_towel hot_towel 
```

```
sudo docker cp hot_towel:/hot_towel/writeup/hot_towel.pdf . 
```
which will transfer the writeup to th host machine. 

Old Notes (including ACM-EC 2015 reviews)  [Google Docs](https://docs.google.com/document/d/1CKmBE7aD2OVAyWJdpNCWGoSn7w9P_zsPnXzOB6u3X_o/edit#heading=h.m9lt02r1sbsr)



