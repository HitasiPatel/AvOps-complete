# Using the API Template

1. Clone or Download the repository to your Local. 
2. Execute the following command to install depedencies : 

```
git config core.hooksPath .githooks
python -m virtualenv venv
source venv/bin/activate 
pip3 install -r requirements.txt
```


## Running the App 

### Inside VSCode

1. Set the connection strings in env.template and save the file as .env
2. Run the following command from the 'app' folder to start the app:
`uvicorn app.app:app --reload --port 3100`
 or run directly from VSCode using Run/Debug Option


### Runing in Dev Containers

1. Set the connection strings in env.template and save the file as .env
2. Open VSCode from api folder and a popup will appear in bottom right to Reopen In DevContainers.
3. Run the app directly from VSCode using Run/Debug Option 


### Running in Docker

```
docker build . -t fastapi-todo
docker run --env-file ./src/.env -p 3100:3100 -t fastapi-todo
```

### Steps for updating your collection name to the createIndexes.sh script so that on deployment, your indexes are created

* Go to the path ```.pipelines/stages/postDeploy/createIndexes.sh```
* Check the collectionList (Line 31) and add/update the name of the collections where you want to have the indexes.
* Currently we have wildcard indexes enabled, you can add other types as and when needed.
